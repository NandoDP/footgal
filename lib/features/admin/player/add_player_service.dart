import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/constant/firebase_constant.dart';
import 'package:footgal/core/provider/firebase_provider.dart';
import 'package:footgal/core/provider/storage_repository.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/models/player_model.dart';
import 'package:footgal/models/stats_model.dart';
import 'package:footgal/models/team_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final addPlayerServiceProvider = Provider(
  (ref) => AddPlayerService(
    firestore: ref.watch(firestoreProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

final getAllTeamsProvider = StreamProvider(
  (ref) => ref.watch(addPlayerServiceProvider).getAllTeams(),
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

  void addPlayer({
    required BuildContext context,
    required String name,
    required int numero,
    required String pays,
    required TeamM team,
    required String position,
    required DateTime date,
    required File? file,
  }) async {
    state = true;
    PlayerM player;
    String uid = const Uuid().v1();

    StatsPlayer stats = StatsPlayer(
      butConcedes: position == 'Gardien' ? {} : null,
      buts: {},
      passesD: {},
      yellowCards: {},
      redCards: {},
      matchs: {},
    );

    for (var e in team.competition) {
      if (position == 'Gardien') {
        stats.butConcedes![e] = 0;
      }
      stats.buts[e] = 0;
      stats.passesD[e] = 0;
      stats.yellowCards[e] = 0;
      stats.redCards[e] = 0;
      stats.matchs[e] = 0;
    }

    if (file != null) {
      final imageRes = await _storageRepository.storeFile(
        path: 'players/${team.name}',
        id: uid,
        file: file,
      );
      imageRes.fold(
        (l) => showSnackBar(context, l.message),
        (r) async {
          String link = r.toString();

          player = PlayerM(
            uid: uid,
            name: name,
            naissance: date,
            pays: pays,
            position: position,
            followers: [],
            stats: stats,
            team: team.name,
            profilePic: link,
            numero: numero,
          );
          await _players.doc(player.uid).set(player.toMap());
        },
      );
    } else {
      player = PlayerM(
        uid: uid,
        name: name,
        numero: numero,
        naissance: date,
        pays: pays,
        position: position,
        followers: [],
        stats: stats,
        team: team.name,
      );
      await _players.doc(player.uid).set(player.toMap());
    }

    team.players.add(uid);
    await _teams.doc(team.name).update(team.toMap());
    state = false;
    // ignore: use_build_context_synchronously
    showSnackBar(context, 'Joueur Ajouter');
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
