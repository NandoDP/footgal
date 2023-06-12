import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/constant/firebase_constant.dart';
import 'package:footgal/core/provider/firebase_provider.dart';
import 'package:footgal/core/provider/storage_repository.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/models/competition.dart';
import 'package:footgal/models/player_model.dart';
import 'package:footgal/models/stats_model.dart';
import 'package:footgal/models/team_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final addTeamServiceProvider = Provider(
  (ref) => AddTeamService(
    firestore: ref.watch(firestoreProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

final getAllCompetsProvider = StreamProvider(
  (ref) => ref.watch(addTeamServiceProvider).getAllCompets(),
);

class AddTeamService extends StateNotifier<bool> {
  final FirebaseFirestore _firestore;
  final StorageRepository _storageRepository;
  AddTeamService({
    required FirebaseFirestore firestore,
    required StorageRepository storageRepository,
  })  : _firestore = firestore,
        _storageRepository = storageRepository,
        super(false);
  CollectionReference get _competition =>
      _firestore.collection(FirebaseConstants.competitionCollection);
  CollectionReference get _teams =>
      _firestore.collection(FirebaseConstants.teamsCollection);
  CollectionReference get _players =>
      _firestore.collection(FirebaseConstants.playersCollection);

  void addTeam({
    required BuildContext context,
    required String name,
    required String pays,
    required List<CompetitionM> competitions,
    required File? file,
  }) async {
    state = true;
    TeamM team;
    String uid = const Uuid().v1();

    StatsTeam statsTeam = StatsTeam(
      buts: {},
      butsConcedes: {},
      matchs: {},
      points: {},
      defaites: {},
      nulls: {},
      victoirs: {},
    );

    for (var e in competitions) {
      statsTeam.buts[e.name] = 0;
      statsTeam.butsConcedes[e.name] = 0;
      statsTeam.matchs[e.name] = 0;
      statsTeam.points[e.name] = 0;
      statsTeam.victoirs[e.name] = 0;
      statsTeam.nulls[e.name] = 0;
      statsTeam.defaites[e.name] = 0;
    }

    // if (file != null) {
    final imageRes = await _storageRepository.storeFile(
      path: 'teams/$name',
      id: uid,
      file: file,
    );
    imageRes.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        String link = r.toString();

        team = TeamM(
          name: name,
          pays: pays,
          profilePic: link,
          players: [],
          competition: competitions.map((e) => e.name).toList(),
          stats: statsTeam,
          followers: [],
          matchs: [],
        );
        await _teams.doc(team.name).set(team.toMap());

        for (var compet in competitions) {
          compet.teams.add(team.name);
          _competition.doc(compet.name).update(compet.toMap());
        }
        state = false;
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Equipe Ajouter');
        // ignore: use_build_context_synchronously
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<CompetitionM>> getAllCompets() {
    return _competition.orderBy('name').snapshots().map(
          (event) => event.docs
              .map(
                (e) => CompetitionM.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  List<String> uids = [
    "7cdc3ca0-ecd9-11ed-8ea1-e16c48f8a6a4",
    "e72a7090-ecd9-11ed-8ea1-e16c48f8a6a4",
    "269e07f0-ecda-11ed-8ea1-e16c48f8a6a4",
    "79835830-ecda-11ed-8ea1-e16c48f8a6a4",
    "cf026620-ecda-11ed-8ea1-e16c48f8a6a4",
    "33dbcff0-ecdb-11ed-8ea1-e16c48f8a6a4",
    "6d106f60-ecdb-11ed-8ea1-e16c48f8a6a4",
    "cb029350-ecdb-11ed-8ea1-e16c48f8a6a4",
    "f65d3550-ecdb-11ed-8ea1-e16c48f8a6a4",
    "2a0d7a40-ecdc-11ed-8ea1-e16c48f8a6a4",
    "5f753330-ecdc-11ed-8ea1-e16c48f8a6a4",
    "9a22de10-ecdc-11ed-8ea1-e16c48f8a6a4",
    "cd0d8910-ecdc-11ed-8ea1-e16c48f8a6a4",
    "f7e05d70-ecdc-11ed-8ea1-e16c48f8a6a4",
    "17dd73b0-ecdd-11ed-8ea1-e16c48f8a6a4",
    "c6b56e60-ecdd-11ed-8ea1-e16c48f8a6a4",
  ];
}
