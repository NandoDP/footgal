import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/faillure.dart';
import 'package:footgal/core/provider/firebase_provider.dart';
import 'package:footgal/core/type_def.dart';
import 'package:footgal/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users => _firestore.collection('users');

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserM> signInWithGoogle(bool isFromLogin) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential;
      if (isFromLogin) {
        userCredential = await _auth.signInWithCredential(credential);
      } else {
        userCredential =
            await _auth.currentUser!.linkWithCredential(credential);
      }

      UserM userM;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userM = UserM(
          name: userCredential.user!.displayName ?? 'No Name',
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          nationalTeam: '',
          otherTeams: [],
          yourTeam: '',
        );

        await _users.doc(userCredential.user!.uid).set(userM.toMap());
      } else {
        userM = await getUserData(userCredential.user!.uid).first;
      }

      return right(userM);
    } on PlatformException catch (e) {
      if (e.code == GoogleSignIn.kNetworkError) {
        String errorMessage =
            "Une erreur réseau (telle qu'un dépassement de délai, une connexion interrompue ou un hôte inaccessible) s'est produite.";
        return left(Faillure(errorMessage.toString()));
      } else {
        String errorMessage = "Quelque chose s'est mal passé.";
        return left(Faillure(errorMessage.toString()));
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      // print(e);
      return left(Faillure(e.toString()));
    }
  }

  FutureEither<UserM> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();

      UserM userM = UserM(
        name: 'No Name',
        // profilePic: Constants.avatarDefault,
        // banner: Constants.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: false, nationalTeam: '', otherTeams: [], yourTeam: '',
        // karma: 0,
        // awards: [],
      );

      await _users.doc(userCredential.user!.uid).set(userM.toMap());

      return right(userM);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Faillure(e.toString()));
    }
  }

  Stream<UserM> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
          (event) => UserM.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
