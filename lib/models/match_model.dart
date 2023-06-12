import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:footgal/models/stats_model.dart';

class MatchM {
  final String uid;
  final String competition;
  final String stade;
  final int statue;
  final DateTime date;
  final DateTime? start1Mt;
  final DateTime? start2Mt;
  final StatsMatch statsMatch;
  final String team1Name;
  final String team1Pic;
  final String team2Name;
  final String team2Pic;
  final List<String> team1Composition;
  final List<String> team2Composition;
  // final Map<String, dynamic>? team1_11;
  // final Map<String, dynamic>? team2_11;
  final Map<String, dynamic> changements;
  final Map<String, dynamic> scoreurs;
  final Map<String, dynamic> yellowCards;
  final Map<String, dynamic> redCards;
  MatchM({
    required this.uid,
    required this.competition,
    required this.stade,
    required this.statue,
    required this.date,
    this.start1Mt,
    this.start2Mt,
    required this.statsMatch,
    required this.team1Name,
    required this.team1Pic,
    required this.team2Name,
    required this.team2Pic,
    required this.team1Composition,
    required this.team2Composition,
    // this.team1_11,
    // this.team2_11,
    required this.changements,
    required this.scoreurs,
    required this.yellowCards,
    required this.redCards,
  });

  MatchM copyWith({
    String? uid,
    String? competition,
    String? stade,
    int? statue,
    DateTime? date,
    DateTime? start1Mt,
    DateTime? start2Mt,
    StatsMatch? statsMatch,
    String? team1Name,
    String? team1Pic,
    String? team2Name,
    String? team2Pic,
    List<String>? team1Composition,
    List<String>? team2Composition,
    // Map<String, dynamic>? team1_11,
    // Map<String, dynamic>? team2_11,
    Map<String, dynamic>? changements,
    Map<String, dynamic>? scoreurs,
    Map<String, dynamic>? yellowCards,
    Map<String, dynamic>? redCards,
  }) {
    return MatchM(
      uid: uid ?? this.uid,
      competition: competition ?? this.competition,
      stade: stade ?? this.stade,
      statue: statue ?? this.statue,
      date: date ?? this.date,
      start1Mt: start1Mt ?? this.start1Mt,
      start2Mt: start2Mt ?? this.start2Mt,
      statsMatch: statsMatch ?? this.statsMatch,
      team1Name: team1Name ?? this.team1Name,
      team1Pic: team1Pic ?? this.team1Pic,
      team2Name: team2Name ?? this.team2Name,
      team2Pic: team2Pic ?? this.team2Pic,
      team1Composition: team1Composition ?? this.team1Composition,
      team2Composition: team2Composition ?? this.team2Composition,
      // team1_11: team1_11 ?? this.team1_11,
      // team2_11: team2_11 ?? this.team2_11,
      changements: changements ?? this.changements,
      scoreurs: scoreurs ?? this.scoreurs,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'competition': competition,
      'stade': stade,
      'statue': statue,
      'date': date.millisecondsSinceEpoch,
      'start1Mt': start1Mt?.millisecondsSinceEpoch,
      'start2Mt': start2Mt?.millisecondsSinceEpoch,
      'statsMatch': statsMatch.toMap(),
      'team1Name': team1Name,
      'team1Pic': team1Pic,
      'team2Name': team2Name,
      'team2Pic': team2Pic,
      'team1Composition': team1Composition,
      'team2Composition': team2Composition,
      // 'team1_11': team1_11,
      // 'team2_11': team2_11,
      'changements': changements,
      'scoreurs': scoreurs,
      'yellowCards': yellowCards,
      'redCards': redCards,
    };
  }

  factory MatchM.fromMap(Map<String, dynamic> map) {
    return MatchM(
      uid: map['uid'] as String,
      competition: map['competition'] as String,
      stade: map['stade'] as String,
      statue: map['statue'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      start1Mt: map['start1Mt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start1Mt'] as int)
          : null,
      start2Mt: map['start2Mt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start2Mt'] as int)
          : null,
      statsMatch: StatsMatch.fromMap(map['statsMatch'] as Map<String, dynamic>),
      team1Name: map['team1Name'] as String,
      team1Pic: map['team1Pic'] as String,
      team2Name: map['team2Name'] as String,
      team2Pic: map['team2Pic'] as String,
      team1Composition: List<String>.from((map['team1Composition'])),
      team2Composition: List<String>.from((map['team2Composition'])),
      // team1_11: map['team1_11'] != null
      //     ? Map<String, dynamic>.from((map['team1_11'] as Map<String, dynamic>))
      //     : null,
      // team2_11: map['team2_11'] != null
      //     ? Map<String, dynamic>.from((map['team2_11'] as Map<String, dynamic>))
      //     : null,
      changements: Map<String, dynamic>.from(
          (map['changements'] as Map<String, dynamic>)),
      scoreurs:
          Map<String, dynamic>.from((map['scoreurs'] as Map<String, dynamic>)),
      yellowCards: Map<String, dynamic>.from(
          (map['yellowCards'] as Map<String, dynamic>)),
      redCards:
          Map<String, dynamic>.from((map['redCards'] as Map<String, dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchM.fromJson(String source) =>
      MatchM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MatchM(uid: $uid, competition: $competition, stade: $stade, date: $date, start1Mt: $start1Mt, start2Mt: $start2Mt, statue: $statue, statsMatch: $statsMatch, team1Name: $team1Name, team2Name: $team2Name, team1Pic: $team1Pic, team2Pic: $team2Pic, team1Composition: $team1Composition, team2Composition: $team2Composition, changements: $changements, scoreurs: $scoreurs, yellowCards: $yellowCards, redCards: $redCards)';
  }

  @override
  bool operator ==(covariant MatchM other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.competition == competition &&
        other.stade == stade &&
        other.statue == statue &&
        other.date == date &&
        other.start1Mt == start1Mt &&
        other.start2Mt == start2Mt &&
        other.statsMatch == statsMatch &&
        other.team1Name == team1Name &&
        other.team1Pic == team1Pic &&
        other.team2Name == team2Name &&
        other.team2Pic == team2Pic &&
        listEquals(other.team1Composition, team1Composition) &&
        listEquals(other.team2Composition, team2Composition) &&
        // mapEquals(other.team1_11, team1_11) &&
        // mapEquals(other.team2_11, team2_11) &&
        mapEquals(other.changements, changements) &&
        mapEquals(other.scoreurs, scoreurs) &&
        mapEquals(other.yellowCards, yellowCards) &&
        mapEquals(other.redCards, redCards);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        competition.hashCode ^
        stade.hashCode ^
        statue.hashCode ^
        date.hashCode ^
        start1Mt.hashCode ^
        start2Mt.hashCode ^
        statsMatch.hashCode ^
        team1Name.hashCode ^
        team1Pic.hashCode ^
        team2Name.hashCode ^
        team2Pic.hashCode ^
        team1Composition.hashCode ^
        team2Composition.hashCode ^
        // team1_11.hashCode ^
        // team2_11.hashCode ^
        changements.hashCode ^
        scoreurs.hashCode ^
        yellowCards.hashCode ^
        redCards.hashCode;
  }
}
