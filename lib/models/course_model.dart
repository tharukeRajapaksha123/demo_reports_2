import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CourseModel {
  final String? id;
  final String name;
  final List moudle_ids;
  CourseModel({
    this.id,
    required this.name,
    required this.moudle_ids,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'moudle_ids': moudle_ids,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      moudle_ids: map['moudle_ids'] ?? [],
    );
  }

  factory CourseModel.fromDocumentSnapshot(DocumentSnapshot map) {
    return CourseModel(
      id: map.id,
      name: (map.data() as Map)['name'] ?? "-",
      moudle_ids: (map.data() as Map)['module_ids'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) =>
      CourseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
