// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:footgal/models/player_model.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:footgal/models/stats_model.dart';

class TeamM {
  final String name;
  final String pays;
  final String profilePic;
  final List<String> players;
  final List<String> matchs;
  final List<String> competition;
  final StatsTeam stats;
  final List<String> followers;
  TeamM({
    required this.name,
    required this.pays,
    required this.profilePic,
    required this.players,
    required this.matchs,
    required this.competition,
    required this.stats,
    required this.followers,
  });

  TeamM copyWith({
    String? name,
    String? pays,
    String? profilePic,
    List<String>? players,
    List<String>? matchs,
    List<String>? competition,
    StatsTeam? stats,
    List<String>? followers,
  }) {
    return TeamM(
      name: name ?? this.name,
      pays: pays ?? this.pays,
      profilePic: profilePic ?? this.profilePic,
      players: players ?? this.players,
      matchs: matchs ?? this.matchs,
      competition: competition ?? this.competition,
      stats: stats ?? this.stats,
      followers: followers ?? this.followers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pays': pays,
      'profilePic': profilePic,
      'players': players,
      'matchs': matchs,
      'competition': competition,
      'stats': stats.toMap(),
      'followers': followers,
    };
  }

  factory TeamM.fromMap(Map<String, dynamic> map) {
    return TeamM(
      name: map['name'] as String,
      pays: map['pays'] as String,
      profilePic: map['profilePic'] as String,
      players: List<String>.from((map['players'])),
      matchs: List<String>.from((map['matchs'])),
      competition: List<String>.from((map['competition'])),
      stats: StatsTeam.fromMap(map['stats']),
      followers: List<String>.from((map['followers'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamM.fromJson(String source) =>
      TeamM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TeamM(name: $name, pays: $pays, profilePic: $profilePic, players: $players, matchs: $matchs, competition: $competition, stats: $stats, followers: $followers)';
  }

  @override
  bool operator ==(covariant TeamM other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.pays == pays &&
        other.profilePic == profilePic &&
        listEquals(other.players, players) &&
        listEquals(other.matchs, matchs) &&
        listEquals(other.competition, competition) &&
        other.stats == stats &&
        listEquals(other.followers, followers);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        pays.hashCode ^
        profilePic.hashCode ^
        players.hashCode ^
        matchs.hashCode ^
        competition.hashCode ^
        stats.hashCode ^
        followers.hashCode;
  }
}
