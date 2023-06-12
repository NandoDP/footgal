import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/constant/firebase_constant.dart';
import 'package:footgal/core/provider/firebase_provider.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/player_model.dart';

final addCompoServicesProvider = StateNotifierProvider<AddCompoServices, bool>(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    return AddCompoServices(firestore: firestore);
  },
);

class AddCompoServices extends StateNotifier<bool> {
  final FirebaseFirestore _firestore;
  // final Ref _ref;
  AddCompoServices({
    required FirebaseFirestore firestore,
    // required Ref ref,
  })  : _firestore = firestore,
        // _ref = ref,
        super(true);

  CollectionReference get _players =>
      _firestore.collection(FirebaseConstants.playersCollection);
  // CollectionReference get _teams =>
  //     _firestore.collection(FirebaseConstants.teamsCollection);
  // CollectionReference get _competition =>
  //     _firestore.collection(FirebaseConstants.competitionCollection);
  CollectionReference get _matchs =>
      _firestore.collection(FirebaseConstants.matchsCollection);

  void addCompo({
    required MatchM match,
    required List<String> teamComposition,
    required int n,
  }) async {
    state = true;
    MatchM matchM = MatchM(
      uid: match.uid,
      competition: match.competition,
      stade: match.stade,
      date: match.date,
      statue: match.statue,
      statsMatch: match.statsMatch,
      team1Name: match.team1Name,
      team1Pic: match.team1Pic,
      team2Name: match.team2Name,
      team2Pic: match.team2Pic,
      team1Composition: n == 0 ? teamComposition : match.team1Composition,
      team2Composition: n == 1 ? teamComposition : match.team2Composition,
      redCards: match.redCards,
      scoreurs: match.scoreurs,
      yellowCards: match.yellowCards,
      changements: match.changements,
    );

    await _matchs.doc(match.uid).update(matchM.toMap());
    state = false;
  }

  void increMatch(List<PlayerM> players, String compet) async {
    for (var player in players) {
      player.stats.matchs[compet]++;
      await _players.doc(player.uid).update(player.toMap());
    }
  }
}
