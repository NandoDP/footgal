// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Article {
  final String uid;
  final String title;
  final String content;
  final DateTime date;
  Article({
    required this.uid,
    required this.title,
    required this.content,
    required this.date,
  });

  Article copyWith({
    String? uid,
    String? title,
    String? content,
    DateTime? date,
  }) {
    return Article(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'content': content,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      uid: map['uid'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) =>
      Article.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Article(uid: $uid, title: $title, content: $content, date: $date)';
  }

  @override
  bool operator ==(covariant Article other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.title == title &&
        other.content == content &&
        other.date == date;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ title.hashCode ^ content.hashCode ^ date.hashCode;
  }
}
