import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/constant/firebase_constant.dart';
import 'package:footgal/core/provider/firebase_provider.dart';
import 'package:footgal/models/competition.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/player_model.dart';
import 'package:footgal/models/team_model.dart';

final matchServicesProvider = StateNotifierProvider<MatchServices, bool>(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    return MatchServices(firestore: firestore, ref: ref);
  },
);

final getUserCompetitionProvider = StreamProvider(
  (ref) => ref.watch(matchServicesProvider.notifier).getUserCompetitions(),
);

final getMatchsByCompetProvider = StreamProvider.family(
  (ref, String name) =>
      ref.watch(matchServicesProvider.notifier).getMatchsByCompet(name),
);

final getCompetitionProvider = StreamProvider.family(
  (ref, String name) =>
      ref.watch(matchServicesProvider.notifier).getCompetionByName(name),
);

final getTeamProvider = StreamProvider.family(
  (ref, String name) =>
      ref.watch(matchServicesProvider.notifier).getTeamByName(name),
);

final getPlayerProvider = StreamProvider.family(
  (ref, String uid) => ref.watch(matchServicesProvider.notifier).getPlayer(uid),
);

final getPlayersMatchProvider = StreamProvider.family(
  (ref, List<String> list) =>
      ref.watch(matchServicesProvider.notifier).getPlayersTitulaire(list),
);

final getMatchTeamsProvider = StreamProvider.family(
  (ref, MatchM match) =>
      ref.watch(matchServicesProvider.notifier).getMatchTeamsByName(match),
);

final getMatchProvider = StreamProvider.family(
  (ref, String uid) => ref.watch(matchServicesProvider.notifier).getMatch(uid),
);

class MatchServices extends StateNotifier<bool> {
  final FirebaseFirestore _firestore;
  final Ref _ref;
  MatchServices({
    required FirebaseFirestore firestore,
    required Ref ref,
  })  : _firestore = firestore,
        _ref = ref,
        super(true);

  CollectionReference get _players =>
      _firestore.collection(FirebaseConstants.playersCollection);
  CollectionReference get _teams =>
      _firestore.collection(FirebaseConstants.teamsCollection);
  CollectionReference get _competition =>
      _firestore.collection(FirebaseConstants.competitionCollection);
  CollectionReference get _matchs =>
      _firestore.collection(FirebaseConstants.matchsCollection);

  Stream<List<CompetitionM>> getUserCompetitions() {
    // final uid = _ref.read(userProvider)!.uid;
    return _competition
        // .where('followers', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CompetitionM> competitions = [];
      for (var doc in event.docs) {
        competitions
            .add(CompetitionM.fromMap(doc.data() as Map<String, dynamic>));
      }
      return competitions;
    });
  }

  Stream<CompetitionM> getCompetionByName(String name) {
    return _competition.doc(name).snapshots().map(
          (event) => CompetitionM.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  Stream<TeamM> getTeamByName(String name) {
    return _teams.doc(name).snapshots().map(
          (event) => TeamM.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  Stream<PlayerM> getPlayer(String uid) {
    return _players.doc(uid).snapshots().map(
          (event) => PlayerM.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  Stream<List<PlayerM>> getPlayersTitulaire(List<String> list) {
    return _players.snapshots().map(
      (event) {
        List<PlayerM> players = [];
        for (var doc in event.docs) {
          final player = PlayerM.fromMap(
            doc.data() as Map<String, dynamic>,
          );
          // print(player.name);
          if (list.contains(player.uid)) {
            players.add(player);
          }
        }
        return players;
      },
    );
  }

  Stream<List<TeamM>> getMatchTeamsByName(MatchM match) {
    return _teams
        .where('name', whereIn: [match.team1Name, match.team2Name])
        .snapshots()
        .map(
          (event) {
            List<TeamM> teams = [];
            for (var doc in event.docs) {
              teams.add(
                TeamM.fromMap(doc.data() as Map<String, dynamic>),
              );
            }
            return teams;
          },
        );
  }

  Stream<MatchM> getMatch(String uid) {
    return _matchs.doc(uid).snapshots().map(
          (event) => MatchM.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  void changeStatueMatch({
    required MatchM match,
    required int statue,
    required BuildContext context,
  }) async {
    state = true;
    MatchM matchM = MatchM(
      uid: match.uid,
      competition: match.competition,
      stade: match.stade,
      date: match.date,
      statue: statue,
      start1Mt: statue == 1 ? DateTime.now() : null,
      start2Mt: statue == 3 ? DateTime.now() : null,
      statsMatch: match.statsMatch,
      team1Name: match.team1Name,
      team1Pic: match.team1Pic,
      team2Name: match.team2Name,
      team2Pic: match.team2Pic,
      team1Composition: match.team1Composition,
      team2Composition: match.team2Composition,
      changements: match.changements,
      redCards: match.redCards,
      scoreurs: match.scoreurs,
      yellowCards: match.yellowCards,
    );
    await _matchs.doc(matchM.uid).update(matchM.toMap());
    state = false;
  }

  void changement({
    required PlayerM player1,
    required PlayerM player2,
    required MatchM match,
    required int minute,
  }) async {
    state = true;
    match.changements['${player1.uid}|${player2.uid}'] = minute;
    player2.stats.matchs[match.competition]++;

    await _matchs.doc(match.uid).update(match.toMap());
    await _players.doc(player2.uid).update(player2.toMap());
    state = false;
  }

  void yellowRedCard({
    required PlayerM player,
    required MatchM match,
    required String card,
    required int minute,
    required int indexTeam,
  }) async {
    state = true;
    if (card == 'Red') {
      player.stats.redCards[match.competition]++;
      match.redCards[player.uid] = minute;
      match.statsMatch.redCard[indexTeam]++;
    } else {
      player.stats.yellowCards[match.competition]++;
      match.yellowCards[player.uid] = minute;
      match.statsMatch.yellowCard[indexTeam]++;
    }

    await _matchs.doc(match.uid).update(match.toMap());
    await _players.doc(player.uid).update(player.toMap());
    state = false;
  }

  void endMatch({
    required TeamM team1,
    required int pt1,
    required TeamM team2,
    required int pt2,
    required String compet,
  }) async {
    state = true;
    team1.stats.points[compet] += pt1;
    if (pt1 == 3) {
      team1.stats.victoirs[compet]++;
      team2.stats.defaites[compet]++;
    } else if (pt1 == 1) {
      team1.stats.nulls[compet]++;
      team2.stats.nulls[compet]++;
    } else {
      team1.stats.defaites[compet]++;
      team2.stats.victoirs[compet]++;
    }
    team2.stats.points[compet] += pt2;

    await _teams.doc(team1.name).update(team1.toMap());
    await _teams.doc(team2.name).update(team2.toMap());
    state = false;
  }

  void goal({
    required PlayerM player,
    required PlayerM? passeur,
    required MatchM match,
    required TeamM team1,
    required TeamM team2,
    required int minute,
    required int indexTeam,
  }) async {
    state = true;
    // stats butteur
    player.stats.buts[match.competition]++;
    // stats L'equipe butteur
    team1.stats.buts[match.competition]++;
    // stats L'equipe qui concede
    team2.stats.butsConcedes[match.competition]++;

    // stats match
    match.statsMatch.buts[indexTeam]++;
    if (passeur != null) {
      // stats passeur
      passeur.stats.passesD[match.competition]++;
      match.scoreurs['${player.uid}|${passeur.uid}'] = minute;
      await _players.doc(passeur.uid).update(passeur.toMap());
    } else {
      match.scoreurs['${player.uid}|'] = minute;
    }

    await _matchs.doc(match.uid).update(match.toMap());
    await _players.doc(player.uid).update(player.toMap());
    await _teams.doc(team1.name).update(team1.toMap());
    await _teams.doc(team2.name).update(team2.toMap());
    state = false;
  }

  Stream<List<MatchM>> getMatchsByCompet(String competitionName) {
    return _matchs
        .where('competition', isEqualTo: competitionName)
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => MatchM.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
