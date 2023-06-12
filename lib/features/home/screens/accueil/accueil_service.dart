import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/constant/firebase_constant.dart';
import 'package:footgal/core/provider/firebase_provider.dart';
import 'package:footgal/models/match_model.dart';

final acceuillServicesProvider = Provider(
  (ref) => AcceuilServices(firestore: ref.watch(firestoreProvider), ref: ref),
);

final getSomeMatchs = StreamProvider(
  (ref) => ref.watch(acceuillServicesProvider).getSomeMatchs(),
);

class AcceuilServices extends StateNotifier<bool> {
  final FirebaseFirestore _firestore;
  final Ref _ref;
  AcceuilServices({
    required FirebaseFirestore firestore,
    required Ref ref,
  })  : _firestore = firestore,
        _ref = ref,
        super(true);

  // CollectionReference get _players =>
  //     _firestore.collection(FirebaseConstants.playersCollection);
  // CollectionReference get _teams =>
  //     _firestore.collection(FirebaseConstants.teamsCollection);
  CollectionReference get _matchs =>
      _firestore.collection(FirebaseConstants.matchsCollection);

  Stream<List<MatchM>> getSomeMatchs() {
    return _matchs
        // .where(
        //   'date',
        //   isLessThanOrEqualTo: DateTime.utc(
        //     DateTime.now().year,
        //     DateTime.now().month,
        //     DateTime.now().day,
        //   ),
        // )
        .snapshots()
        .map(
      (event) {
        List<MatchM> matchs = [];
        for (var doc in event.docs) {
          if (matchs.length < 10) {
            matchs.add(
              MatchM.fromMap(doc.data() as Map<String, dynamic>),
            );
          }
        }
        return matchs;
      },
    );
  }
}
