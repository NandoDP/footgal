import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/constant/firebase_constant.dart';
import 'package:footgal/core/provider/firebase_provider.dart';
import 'package:footgal/core/provider/storage_repository.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/models/competition.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/player_model.dart';
import 'package:footgal/models/stats_model.dart';
import 'package:footgal/models/team_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final addMatchServiceProvider = Provider(
  (ref) => AddPlayerService(
    firestore: ref.watch(firestoreProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

final getAllCompetitionProvider = StreamProvider(
  (ref) => ref.watch(addMatchServiceProvider).getAllCompetition(),
);

class AddPlayerService extends StateNotifier<bool> {
  final FirebaseFirestore _firestore;
  final StorageRepository _storageRepository;
  AddPlayerService({
    required FirebaseFirestore firestore,
    required StorageRepository storageRepository,
  })  : _firestore = firestore,
        _storageRepository = storageRepository,
        super(false);
  CollectionReference get _teams =>
      _firestore.collection(FirebaseConstants.teamsCollection);
  CollectionReference get _players =>
      _firestore.collection(FirebaseConstants.playersCollection);
  CollectionReference get _matchs =>
      _firestore.collection(FirebaseConstants.matchsCollection);
  CollectionReference get _competition =>
      _firestore.collection(FirebaseConstants.competitionCollection);

  void addMatch({
    required BuildContext context,
    required String uid,
    // required MatchM match,
    required String stade,
    required CompetitionM compet,
    required String journee,
    required TeamM team1,
    required TeamM team2,
    // required List<String> team1Composition,
    // required List<String> team2Composition,
    required DateTime date,
  }) async {
    state = true;
    // String uid = const Uuid().v1();
    StatsMatch statsMatch = StatsMatch(
      buts: [0, 0],
      tirs: [0, 0],
      tirsCadres: [0, 0],
      possession: [0, 0],
      passes: [0, 0],
      precisionPasses: [0, 0],
      fautes: [0, 0],
      yellowCard: [0, 0],
      redCard: [0, 0],
      horsJeu: [0, 0],
      corners: [0, 0],
    );

    MatchM match = MatchM(
      uid: uid,
      competition: compet.name,
      stade: stade,
      date: date,
      statsMatch: statsMatch,
      team1Name: team1.name,
      team1Pic: team1.profilePic,
      team2Name: team2.name,
      team2Pic: team2.profilePic,
      team1Composition: [''],
      // team1Composition: team1Composition,
      team2Composition: [''],
      // team2Composition: team2Composition,
      redCards: {},
      scoreurs: {},
      yellowCards: {},
      statue: 0,
      changements: {},
    );
    compet.matchs[journee].add(uid);

    await _matchs.doc(match.uid).set(match.toMap());
    await _competition.doc(compet.name).update(compet.toMap());
    state = false;
    // ignore: use_build_context_synchronously
    showSnackBar(context, 'Match Ajouter');
    // ignore: use_build_context_synchronously
    // Routemaster.of(context).pop();
  }

  Stream<List<CompetitionM>> getAllCompetition() {
    return _competition.snapshots().map(
          (event) => event.docs
              .map(
                (e) => CompetitionM.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
