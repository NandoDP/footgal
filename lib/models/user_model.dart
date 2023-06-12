// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

// import 'package:flutter/foundation.dart';

class UserM {
  final String name;
  final String uid;
  final bool isAuthenticated;
  final bool isAdmin;
  final String yourTeam;
  final String nationalTeam;
  final List<String> otherTeams;
  UserM({
    required this.name,
    required this.uid,
    required this.isAuthenticated,
    this.isAdmin = false,
    required this.yourTeam,
    required this.nationalTeam,
    required this.otherTeams,
  });
  // UserM({
  //   required this.name,
  //   required this.uid,
  //   required this.isAuthenticated,
  //   this.isAdmin = false,
  // });

  // UserM copyWith({
  //   String? name,
  //   String? uid,
  //   bool? isAuthenticated,
  //   bool? isAdmin,
  // }) {
  //   return UserM(
  //     name: name ?? this.name,
  //     uid: uid ?? this.uid,
  //     isAuthenticated: isAuthenticated ?? this.isAuthenticated,
  //     isAdmin: isAdmin ?? this.isAdmin,
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'name': name,
  //     'uid': uid,
  //     'isAuthenticated': isAuthenticated,
  //     'isAdmin': isAdmin,
  //   };
  // }

  // factory UserM.fromMap(Map<String, dynamic> map) {
  //   return UserM(
  //     name: map['name'] as String,
  //     uid: map['uid'] as String,
  //     isAuthenticated: map['isAuthenticated'] as bool,
  //     isAdmin: map['isAdmin'] as bool,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory UserM.fromJson(String source) =>
  //     UserM.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // String toString() {
  //   return 'UserM(name: $name, uid: $uid, isAuthenticated: $isAuthenticated, isAdmin: $isAdmin)';
  // }

  // @override
  // bool operator ==(covariant UserM other) {
  //   if (identical(this, other)) return true;

  //   return other.name == name &&
  //       other.uid == uid &&
  //       other.isAuthenticated == isAuthenticated &&
  //       other.isAdmin == isAdmin;
  // }

  // @override
  // int get hashCode {
  //   return name.hashCode ^
  //       uid.hashCode ^
  //       isAuthenticated.hashCode ^
  //       isAdmin.hashCode;
  // }

  UserM copyWith({
    String? name,
    String? uid,
    bool? isAuthenticated,
    bool? isAdmin,
    String? yourTeam,
    String? nationalTeam,
    List<String>? otherTeams,
  }) {
    return UserM(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isAdmin: isAdmin ?? this.isAdmin,
      yourTeam: yourTeam ?? this.yourTeam,
      nationalTeam: nationalTeam ?? this.nationalTeam,
      otherTeams: otherTeams ?? this.otherTeams,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'isAdmin': isAdmin,
      'yourTeam': yourTeam,
      'nationalTeam': nationalTeam,
      'otherTeams': otherTeams,
    };
  }

  factory UserM.fromMap(Map<String, dynamic> map) {
    return UserM(
      name: map['name'] as String,
      uid: map['uid'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      isAdmin: map['isAdmin'] as bool,
      yourTeam: map['yourTeam'] as String,
      nationalTeam: map['nationalTeam'] as String,
      otherTeams: List<String>.from((map['otherTeams'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserM.fromJson(String source) =>
      UserM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserM(name: $name, uid: $uid, isAuthenticated: $isAuthenticated, isAdmin: $isAdmin, yourTeam: $yourTeam, nationalTeam: $nationalTeam, otherTeams: $otherTeams)';
  }

  @override
  bool operator ==(covariant UserM other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.isAdmin == isAdmin &&
        other.yourTeam == yourTeam &&
        other.nationalTeam == nationalTeam &&
        listEquals(other.otherTeams, otherTeams);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        uid.hashCode ^
        isAuthenticated.hashCode ^
        isAdmin.hashCode ^
        yourTeam.hashCode ^
        nationalTeam.hashCode ^
        otherTeams.hashCode;
  }
}
