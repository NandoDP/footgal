import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/constant/firebase_constant.dart';
import 'package:footgal/core/provider/firebase_provider.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';
import 'package:footgal/models/competition.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/player_model.dart';
import 'package:footgal/models/team_model.dart';

final profilsServicesProvider = StateNotifierProvider<ProfilsServices, bool>(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    return ProfilsServices(firestore: firestore, ref: ref);
  },
);

final getTopScoreurProvider = StreamProvider.family(
  (ref, String compet) =>
      ref.watch(profilsServicesProvider.notifier).getTopScoreurs(compet),
);

final getTopPasseursProvider = StreamProvider.family(
  (ref, String compet) =>
      ref.watch(profilsServicesProvider.notifier).getTopPasseur(compet),
);

final getTopYellowCardProvider = StreamProvider.family(
  (ref, String compet) =>
      ref.watch(profilsServicesProvider.notifier).getTopYellowCard(compet),
);

final getTopRedCardProvider = StreamProvider.family(
  (ref, String compet) =>
      ref.watch(profilsServicesProvider.notifier).getTopRedCard(compet),
);

final getMatchsByTeamProvider = StreamProvider.family(
  (ref, String team) =>
      ref.watch(profilsServicesProvider.notifier).getMatchsTeam(team),
);

class ProfilsServices extends StateNotifier<bool> {
  final FirebaseFirestore _firestore;
  final Ref _ref;
  ProfilsServices({
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

  Stream<List<PlayerM>> getTopScoreurs(String compet) {
    return _players.snapshots().map(
      (event) {
        List<PlayerM> players = [];
        for (var doc in event.docs) {
          players.add(
            PlayerM.fromMap(
              doc.data() as Map<String, dynamic>,
            ),
          );
        }
        players.sort(
          (a, b) => a.stats.buts[compet].compareTo(b.stats.buts[compet]),
        );
        return players.reversed.toList().getRange(0, 30).toList();
      },
    );
  }

  Stream<List<PlayerM>> getTopPasseur(String compet) {
    return _players.snapshots().map(
      (event) {
        List<PlayerM> players = [];
        for (var doc in event.docs) {
          players.add(
            PlayerM.fromMap(
              doc.data() as Map<String, dynamic>,
            ),
          );
        }
        players.sort(
          (a, b) => a.stats.passesD[compet].compareTo(b.stats.passesD[compet]),
        );
        return players.reversed.toList().getRange(0, 30).toList();
      },
    );
  }

  Stream<List<PlayerM>> getTopYellowCard(String compet) {
    return _players.snapshots().map(
      (event) {
        List<PlayerM> players = [];
        for (var doc in event.docs) {
          players.add(
            PlayerM.fromMap(
              doc.data() as Map<String, dynamic>,
            ),
          );
        }
        players.sort(
          (a, b) => a.stats.yellowCards[compet]
              .compareTo(b.stats.yellowCards[compet]),
        );
        return players.reversed.toList().getRange(0, 30).toList();
      },
    );
  }

  Stream<List<PlayerM>> getTopRedCard(String compet) {
    return _players.snapshots().map(
      (event) {
        List<PlayerM> players = [];
        for (var doc in event.docs) {
          players.add(
            PlayerM.fromMap(
              doc.data() as Map<String, dynamic>,
            ),
          );
        }
        players.sort(
          (a, b) =>
              a.stats.redCards[compet].compareTo(b.stats.redCards[compet]),
        );
        return players.reversed.toList().getRange(0, 30).toList();
      },
    );
  }

  Stream<List<MatchM>> getMatchsTeam(String team) {
    return _matchs.snapshots().map((event) {
      List<MatchM> matchs = [];
      for (var doc in event.docs) {
        MatchM match = MatchM.fromMap(
          doc.data() as Map<String, dynamic>,
        );
        if (match.team1Name == team || match.team2Name == team) {
          matchs.add(match);
        }
      }
      return matchs;
    });
  }

  void abonnementPlayer(PlayerM player) async {
    final uid = _ref.read(userProvider)!.uid;
    if (player.followers.contains(uid)) {
      player.followers.remove(uid);
    } else {
      player.followers.add(uid);
    }
    await _players.doc(player.uid).update(player.toMap());
  }

  void abonnementTeam(TeamM team) async {
    final uid = _ref.read(userProvider)!.uid;
    if (team.followers.contains(uid)) {
      team.followers.remove(uid);
    } else {
      team.followers.add(uid);
    }
    await _teams.doc(team.name).update(team.toMap());
  }

  void abonnementCompetition(CompetitionM competition) async {
    final uid = _ref.read(userProvider)!.uid;
    if (competition.followers.contains(uid)) {
      competition.followers.remove(uid);
    } else {
      competition.followers.add(uid);
    }
    await _competition.doc(competition.name).update(competition.toMap());
  }
}
