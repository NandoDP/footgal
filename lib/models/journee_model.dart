// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:footgal/models/match_model.dart';

class JourneeM {
  final List<MatchM> journee;
  JourneeM({
    required this.journee,
  });

  JourneeM copyWith({
    List<MatchM>? journee,
  }) {
    return JourneeM(
      journee: journee ?? this.journee,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'journee': journee.map((x) => x.toMap()).toList(),
    };
  }

  factory JourneeM.fromMap(Map<String, dynamic> map) {
    return JourneeM(
      journee: List<MatchM>.from(
        (map['journee'] as List<int>).map<MatchM>(
          (x) => MatchM.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory JourneeM.fromJson(String source) =>
      JourneeM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'JourneeM(journee: $journee)';

  @override
  bool operator ==(covariant JourneeM other) {
    if (identical(this, other)) return true;

    return listEquals(other.journee, journee);
  }

  @override
  int get hashCode => journee.hashCode;
}
