import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserGroupModel {
  final String? id;
  final List course_ids;
  final List diary_ids;
  final List playbook_ids;
  final List survey_ids;
  final String title;
  final List trainers;
  UserGroupModel({
    this.id,
    required this.course_ids,
    required this.diary_ids,
    required this.playbook_ids,
    required this.survey_ids,
    required this.title,
    required this.trainers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'course_ids': course_ids,
      'diary_ids': diary_ids,
      'playbook_ids': playbook_ids,
      'survey_ids': survey_ids,
      'title': title,
      'trainers': trainers,
    };
  }

  factory UserGroupModel.fromMap(Map<String, dynamic> map) {
    return UserGroupModel(
      id: map['id'] != null ? map['id'] as String : null,
      course_ids: map['course_ids'] ?? [],
      diary_ids: map['diary_ids'] ?? [],
      playbook_ids: map['playbook_ids'] ?? [],
      survey_ids: map['survey_ids'] ?? [],
      title: map['title'] as String,
      trainers: map['trainers'] ?? [],
    );
  }
  factory UserGroupModel.fromDocumentSnapshot(DocumentSnapshot map) {
    return UserGroupModel(
      id: map.id,
      course_ids: (map.data() as Map)['course_ids'] ?? [],
      diary_ids: (map.data() as Map)['diary_ids'] ?? [],
      playbook_ids: (map.data() as Map)['playbook_ids'] ?? [],
      survey_ids: (map.data() as Map)['survey_ids'] ?? [],
      title: (map.data() as Map)['title'] as String,
      trainers: (map.data() as Map)['trainers'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserGroupModel.fromJson(String source) =>
      UserGroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
