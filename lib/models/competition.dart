// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CompetitionM {
  final String name;
  final String profilePic;
  final List<String> followers;
  final List<String> teams;
  final Map<String, dynamic> matchs;
  CompetitionM({
    required this.name,
    required this.profilePic,
    required this.followers,
    required this.teams,
    required this.matchs,
  });

  CompetitionM copyWith({
    String? name,
    String? profilePic,
    List<String>? followers,
    List<String>? teams,
    Map<String, dynamic>? matchs,
  }) {
    return CompetitionM(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      followers: followers ?? this.followers,
      teams: teams ?? this.teams,
      matchs: matchs ?? this.matchs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'followers': followers,
      'teams': teams,
      'matchs': matchs,
    };
  }

  factory CompetitionM.fromMap(Map<String, dynamic> map) {
    return CompetitionM(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      followers: List<String>.from((map['followers'])),
      teams: List<String>.from((map['teams'])),
      matchs:
          Map<String, dynamic>.from((map['matchs'] as Map<String, dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory CompetitionM.fromJson(String source) =>
      CompetitionM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompetitionM(name: $name, profilePic: $profilePic, followers: $followers, teams: $teams, matchs: $matchs)';
  }

  @override
  bool operator ==(covariant CompetitionM other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profilePic == profilePic &&
        listEquals(other.followers, followers) &&
        listEquals(other.teams, teams) &&
        mapEquals(other.matchs, matchs);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePic.hashCode ^
        followers.hashCode ^
        teams.hashCode ^
        matchs.hashCode;
  }
}

class ClassementPlayer {
  final String uid;
  final int nbr;
  ClassementPlayer({
    required this.uid,
    required this.nbr,
  });

  ClassementPlayer copyWith({
    String? uid,
    int? nbr,
  }) {
    return ClassementPlayer(
      uid: uid ?? this.uid,
      nbr: nbr ?? this.nbr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nbr': nbr,
    };
  }

  factory ClassementPlayer.fromMap(Map<String, dynamic> map) {
    return ClassementPlayer(
      uid: map['uid'] as String,
      nbr: map['nbr'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassementPlayer.fromJson(String source) =>
      ClassementPlayer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ClassementPlayer(uid: $uid, nbr: $nbr)';

  @override
  bool operator ==(covariant ClassementPlayer other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.nbr == nbr;
  }

  @override
  int get hashCode => uid.hashCode ^ nbr.hashCode;
}

class ClassementTeam {
  final String team;
  final int matchsJouer;
  final int butsMarques;
  final int butsEccaisser;
  final int points;
  ClassementTeam({
    required this.team,
    required this.matchsJouer,
    required this.butsMarques,
    required this.butsEccaisser,
    required this.points,
  });

  ClassementTeam copyWith({
    String? team,
    int? matchsJouer,
    int? butsMarques,
    int? butsEccaisser,
    int? points,
  }) {
    return ClassementTeam(
      team: team ?? this.team,
      matchsJouer: matchsJouer ?? this.matchsJouer,
      butsMarques: butsMarques ?? this.butsMarques,
      butsEccaisser: butsEccaisser ?? this.butsEccaisser,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'team': team,
      'matchsJouer': matchsJouer,
      'butsMarques': butsMarques,
      'butsEccaisser': butsEccaisser,
      'points': points,
    };
  }

  factory ClassementTeam.fromMap(Map<String, dynamic> map) {
    return ClassementTeam(
      team: map['team'] as String,
      matchsJouer: map['matchsJouer'] as int,
      butsMarques: map['butsMarques'] as int,
      butsEccaisser: map['butsEccaisser'] as int,
      points: map['points'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassementTeam.fromJson(String source) =>
      ClassementTeam.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassementTeam(team: $team, matchsJouer: $matchsJouer, butsMarques: $butsMarques, butsEccaisser: $butsEccaisser, points: $points)';
  }

  @override
  bool operator ==(covariant ClassementTeam other) {
    if (identical(this, other)) return true;

    return other.team == team &&
        other.matchsJouer == matchsJouer &&
        other.butsMarques == butsMarques &&
        other.butsEccaisser == butsEccaisser &&
        other.points == points;
  }

  @override
  int get hashCode {
    return team.hashCode ^
        matchsJouer.hashCode ^
        butsMarques.hashCode ^
        butsEccaisser.hashCode ^
        points.hashCode;
  }
}
