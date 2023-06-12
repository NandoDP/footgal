// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class StatsPlayer {
  final Map<String, dynamic> buts;
  final Map<String, dynamic> passesD;
  final Map<String, dynamic>? butConcedes;
  final Map<String, dynamic> yellowCards;
  final Map<String, dynamic> redCards;
  final Map<String, dynamic> matchs;
  StatsPlayer({
    required this.buts,
    required this.passesD,
    this.butConcedes,
    required this.yellowCards,
    required this.redCards,
    required this.matchs,
  });

  StatsPlayer copyWith({
    Map<String, dynamic>? buts,
    Map<String, dynamic>? passesD,
    Map<String, dynamic>? butConcedes,
    Map<String, dynamic>? yellowCards,
    Map<String, dynamic>? redCards,
    Map<String, dynamic>? matchs,
  }) {
    return StatsPlayer(
      buts: buts ?? this.buts,
      passesD: passesD ?? this.passesD,
      butConcedes: butConcedes ?? this.butConcedes,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
      matchs: matchs ?? this.matchs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buts': buts,
      'passesD': passesD,
      'butConcedes': butConcedes,
      'yellowCards': yellowCards,
      'redCards': redCards,
      'matchs': matchs,
    };
  }

  factory StatsPlayer.fromMap(Map<String, dynamic> map) {
    return StatsPlayer(
      buts: Map<String, dynamic>.from((map['buts'] as Map<String, dynamic>)),
      passesD:
          Map<String, dynamic>.from((map['passesD'] as Map<String, dynamic>)),
      butConcedes: map['butConcedes'] != null
          ? Map<String, dynamic>.from(
              (map['butConcedes'] as Map<String, dynamic>))
          : null,
      yellowCards: Map<String, dynamic>.from(
          (map['yellowCards'] as Map<String, dynamic>)),
      redCards:
          Map<String, dynamic>.from((map['redCards'] as Map<String, dynamic>)),
      matchs:
          Map<String, dynamic>.from((map['matchs'] as Map<String, dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatsPlayer.fromJson(String source) =>
      StatsPlayer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatsPlayer(buts: $buts, passesD: $passesD, butConcedes: $butConcedes, yellowCards: $yellowCards, redCards: $redCards, matchs: $matchs)';
  }

  @override
  bool operator ==(covariant StatsPlayer other) {
    if (identical(this, other)) return true;

    return mapEquals(other.buts, buts) &&
        mapEquals(other.passesD, passesD) &&
        mapEquals(other.butConcedes, butConcedes) &&
        mapEquals(other.yellowCards, yellowCards) &&
        mapEquals(other.redCards, redCards) &&
        mapEquals(other.matchs, matchs);
  }

  @override
  int get hashCode {
    return buts.hashCode ^
        passesD.hashCode ^
        butConcedes.hashCode ^
        yellowCards.hashCode ^
        redCards.hashCode ^
        matchs.hashCode;
  }
}

class StatsTeam {
  final Map<String, dynamic> buts;
  final Map<String, dynamic> butsConcedes;
  final Map<String, dynamic> matchs;
  final Map<String, dynamic> points;
  final Map<String, dynamic> victoirs;
  final Map<String, dynamic> nulls;
  final Map<String, dynamic> defaites;
  StatsTeam({
    required this.buts,
    required this.butsConcedes,
    required this.matchs,
    required this.points,
    required this.victoirs,
    required this.nulls,
    required this.defaites,
  });

  StatsTeam copyWith({
    Map<String, dynamic>? buts,
    Map<String, dynamic>? butsConcedes,
    Map<String, dynamic>? matchs,
    Map<String, dynamic>? points,
    Map<String, dynamic>? victoirs,
    Map<String, dynamic>? nulls,
    Map<String, dynamic>? defaites,
  }) {
    return StatsTeam(
      buts: buts ?? this.buts,
      butsConcedes: butsConcedes ?? this.butsConcedes,
      matchs: matchs ?? this.matchs,
      points: points ?? this.points,
      victoirs: victoirs ?? this.victoirs,
      nulls: nulls ?? this.nulls,
      defaites: defaites ?? this.defaites,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buts': buts,
      'butsConcedes': butsConcedes,
      'matchs': matchs,
      'points': points,
      'victoirs': victoirs,
      'nulls': nulls,
      'defaites': defaites,
    };
  }

  factory StatsTeam.fromMap(Map<String, dynamic> map) {
    return StatsTeam(
      buts: Map<String, dynamic>.from((map['buts'] as Map<String, dynamic>)),
      butsConcedes: Map<String, dynamic>.from(
          (map['butsConcedes'] as Map<String, dynamic>)),
      matchs:
          Map<String, dynamic>.from((map['matchs'] as Map<String, dynamic>)),
      points:
          Map<String, dynamic>.from((map['points'] as Map<String, dynamic>)),
      victoirs:
          Map<String, dynamic>.from((map['victoirs'] as Map<String, dynamic>)),
      nulls: Map<String, dynamic>.from((map['nulls'] as Map<String, dynamic>)),
      defaites:
          Map<String, dynamic>.from((map['defaites'] as Map<String, dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatsTeam.fromJson(String source) =>
      StatsTeam.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatsTeam(buts: $buts, butsConcedes: $butsConcedes, matchs: $matchs, points: $points, victoirs: $victoirs, nulls: $nulls, defaites: $defaites)';
  }

  @override
  bool operator ==(covariant StatsTeam other) {
    if (identical(this, other)) return true;

    return mapEquals(other.buts, buts) &&
        mapEquals(other.butsConcedes, butsConcedes) &&
        mapEquals(other.matchs, matchs) &&
        mapEquals(other.victoirs, victoirs) &&
        mapEquals(other.nulls, nulls) &&
        mapEquals(other.defaites, defaites) &&
        mapEquals(other.points, points);
  }

  @override
  int get hashCode {
    return buts.hashCode ^
        butsConcedes.hashCode ^
        matchs.hashCode ^
        victoirs.hashCode ^
        nulls.hashCode ^
        defaites.hashCode ^
        points.hashCode;
  }
}

class StatsMatch {
  final List<int> buts;
  final List<int> tirs;
  final List<int> tirsCadres;
  final List<int> possession;
  final List<int> passes;
  final List<int> precisionPasses;
  final List<int> fautes;
  final List<int> yellowCard;
  final List<int> redCard;
  final List<int> horsJeu;
  final List<int> corners;
  StatsMatch({
    required this.buts,
    required this.tirs,
    required this.tirsCadres,
    required this.possession,
    required this.passes,
    required this.precisionPasses,
    required this.fautes,
    required this.yellowCard,
    required this.redCard,
    required this.horsJeu,
    required this.corners,
  });

  StatsMatch copyWith({
    List<int>? buts,
    List<int>? tirs,
    List<int>? tirsCadres,
    List<int>? possession,
    List<int>? passes,
    List<int>? precisionPasses,
    List<int>? fautes,
    List<int>? yellowCard,
    List<int>? redCard,
    List<int>? horsJeu,
    List<int>? corners,
  }) {
    return StatsMatch(
      buts: buts ?? this.buts,
      tirs: tirs ?? this.tirs,
      tirsCadres: tirsCadres ?? this.tirsCadres,
      possession: possession ?? this.possession,
      passes: passes ?? this.passes,
      precisionPasses: precisionPasses ?? this.precisionPasses,
      fautes: fautes ?? this.fautes,
      yellowCard: yellowCard ?? this.yellowCard,
      redCard: redCard ?? this.redCard,
      horsJeu: horsJeu ?? this.horsJeu,
      corners: corners ?? this.corners,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buts': buts,
      'tirs': tirs,
      'tirsCadres': tirsCadres,
      'possession': possession,
      'passes': passes,
      'precisionPasses': precisionPasses,
      'fautes': fautes,
      'yellowCard': yellowCard,
      'redCard': redCard,
      'horsJeu': horsJeu,
      'corners': corners,
    };
  }

  factory StatsMatch.fromMap(Map<String, dynamic> map) {
    return StatsMatch(
      buts: List<int>.from((map['buts'])),
      tirs: List<int>.from((map['tirs'])),
      tirsCadres: List<int>.from((map['tirsCadres'])),
      possession: List<int>.from((map['possession'])),
      passes: List<int>.from((map['passes'])),
      precisionPasses: List<int>.from((map['precisionPasses'])),
      fautes: List<int>.from((map['fautes'])),
      yellowCard: List<int>.from((map['yellowCard'])),
      redCard: List<int>.from((map['redCard'])),
      horsJeu: List<int>.from((map['horsJeu'])),
      corners: List<int>.from((map['corners'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatsMatch.fromJson(String source) =>
      StatsMatch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatsMatch(buts: $buts, tirs: $tirs, tirsCadres: $tirsCadres, possession: $possession, passes: $passes, precisionPasses: $precisionPasses, fautes: $fautes, yellowCard: $yellowCard, redCard: $redCard, horsJeu: $horsJeu, corners: $corners)';
  }

  @override
  bool operator ==(covariant StatsMatch other) {
    if (identical(this, other)) return true;

    return listEquals(other.buts, buts) &&
        listEquals(other.tirs, tirs) &&
        listEquals(other.tirsCadres, tirsCadres) &&
        listEquals(other.possession, possession) &&
        listEquals(other.passes, passes) &&
        listEquals(other.precisionPasses, precisionPasses) &&
        listEquals(other.fautes, fautes) &&
        listEquals(other.yellowCard, yellowCard) &&
        listEquals(other.redCard, redCard) &&
        listEquals(other.horsJeu, horsJeu) &&
        listEquals(other.corners, corners);
  }

  @override
  int get hashCode {
    return buts.hashCode ^
        tirs.hashCode ^
        tirsCadres.hashCode ^
        possession.hashCode ^
        passes.hashCode ^
        precisionPasses.hashCode ^
        fautes.hashCode ^
        yellowCard.hashCode ^
        redCard.hashCode ^
        horsJeu.hashCode ^
        corners.hashCode;
  }
}
