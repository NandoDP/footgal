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

final addCompetServiceProvider = Provider(
  (ref) => AddCompetService(
    firestore: ref.watch(firestoreProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

final getAllTeamsProvider = StreamProvider(
  (ref) => ref.watch(addCompetServiceProvider).getAllTeams(),
);

class AddCompetService extends StateNotifier<bool> {
  final FirebaseFirestore _firestore;
  final StorageRepository _storageRepository;
  AddCompetService({
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

  void addCompet({
    required BuildContext context,
    required String name,
    required String pays,
    required List<TeamM> teams,
    required File? file,
  }) async {
    state = true;
    CompetitionM competition;
    String uid = const Uuid().v1();

    final imageRes = await _storageRepository.storeFile(
      path: 'competition/$name',
      id: uid,
      file: file,
    );
    imageRes.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        String link = r.toString();
        List<String> journees =
            Iterable.generate(26).map((e) => 'Journee ${e + 1}').toList();

        Map<String, dynamic> match = {};
        for (var element in journees) {
          match[element] = [];
        }

        competition = CompetitionM(
          name: name,
          profilePic: link,
          followers: [],
          teams: teams.map((e) => e.name).toList(),
          matchs: match,
        );
        await _competition.doc(competition.name).set(competition.toMap());

        for (var team in teams) {
          team.competition.add(competition.name);
          _teams.doc(team.name).update(team.toMap());
        }
        state = false;
      },
    );

    // ignore: use_build_context_synchronously
    showSnackBar(context, 'Competition Ajouter');
    // ignore: use_build_context_synchronously
    Routemaster.of(context).pop();
  }

  Stream<List<TeamM>> getAllTeams() {
    return _teams.orderBy('name').snapshots().map(
          (event) => event.docs
              .map(
                (e) => TeamM.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
