// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:footgal/models/stats_model.dart';

class PlayerM {
  final String uid;
  final String name; //
  final int numero; //
  final DateTime naissance; //
  final String pays; //
  final String? profilePic; //
  final String position; //
  final List<String> followers;
  final StatsPlayer stats;
  final String team; //
  PlayerM({
    required this.uid,
    required this.name,
    required this.numero,
    required this.naissance,
    required this.pays,
    this.profilePic,
    required this.position,
    required this.followers,
    required this.stats,
    required this.team,
  });

  PlayerM copyWith({
    String? uid,
    String? name,
    int? numero,
    DateTime? naissance,
    String? pays,
    String? profilePic,
    String? position,
    List<String>? followers,
    StatsPlayer? stats,
    String? team,
  }) {
    return PlayerM(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      numero: numero ?? this.numero,
      naissance: naissance ?? this.naissance,
      pays: pays ?? this.pays,
      profilePic: profilePic ?? this.profilePic,
      position: position ?? this.position,
      followers: followers ?? this.followers,
      stats: stats ?? this.stats,
      team: team ?? this.team,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'numero': numero,
      'naissance': naissance.millisecondsSinceEpoch,
      'pays': pays,
      'profilePic': profilePic,
      'position': position,
      'followers': followers,
      'stats': stats.toMap(),
      'team': team,
    };
  }

  factory PlayerM.fromMap(Map<String, dynamic> map) {
    return PlayerM(
      uid: map['uid'] as String,
      name: map['name'] as String,
      numero: map['numero'] as int,
      naissance: DateTime.fromMillisecondsSinceEpoch(map['naissance'] as int),
      pays: map['pays'] as String,
      profilePic:
          map['profilePic'] != null ? map['profilePic'] as String : null,
      position: map['position'] as String,
      followers: List<String>.from((map['followers'])),
      stats: StatsPlayer.fromMap(map['stats']),
      team: map['team'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerM.fromJson(String source) =>
      PlayerM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayerM(uid: $uid, name: $name, numero: $numero, naissance: $naissance, pays: $pays, profilePic: $profilePic, position: $position, followers: $followers, stats: $stats, team: $team)';
  }

  @override
  bool operator ==(covariant PlayerM other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.numero == numero &&
        other.naissance == naissance &&
        other.pays == pays &&
        other.profilePic == profilePic &&
        other.position == position &&
        listEquals(other.followers, followers) &&
        other.stats == stats &&
        other.team == team;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        numero.hashCode ^
        naissance.hashCode ^
        pays.hashCode ^
        profilePic.hashCode ^
        position.hashCode ^
        followers.hashCode ^
        stats.hashCode ^
        team.hashCode;
  }
}
