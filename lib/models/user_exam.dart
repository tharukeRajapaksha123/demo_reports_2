// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserExamModel {
  final String? username;
  final String module_name;
  final int total_questions;
  final DateTime completed_at;
  final List correct_answers;
  final Map user_answers;
  final String? grpId;

  UserExamModel({
    this.username,
    required this.module_name,
    required this.total_questions,
    required this.completed_at,
    required this.correct_answers,
    required this.user_answers,
    this.grpId,
  });

  factory UserExamModel.fromMap(Map<String, dynamic> postMap) {
    return UserExamModel(
      module_name: postMap["module_name"] ?? "",
      total_questions: postMap["total_questions"] ?? 0,
      completed_at: postMap["completed_at"] != null
          ? DateTime.fromMillisecondsSinceEpoch(postMap["completed_at"])
          : DateTime.now(),
      correct_answers: postMap["correct_answers"] ?? [],
      user_answers: postMap["user_answers"] ?? [],
    );
  }
  factory UserExamModel.fromDocumentSnapshot(DocumentSnapshot postMap) {
    return UserExamModel(
      module_name: (postMap.data() as Map)["module_name"] ?? "",
      total_questions: (postMap.data() as Map)["total_questions"] ?? 0,
      completed_at: (postMap.data() as Map)["completed_at"] != null
          ? (postMap.data() as Map)["completed_at"].toDate()
          : DateTime.now(),
      correct_answers: (postMap.data() as Map)["correct_answers"] ?? [],
      user_answers: (postMap.data() as Map)["user_answers"] ?? {},
    );
  }
}
