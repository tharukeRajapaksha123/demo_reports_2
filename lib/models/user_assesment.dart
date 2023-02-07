// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAssesmentModel {
  final String? id;
  final String? userId;
  final String username;
  final String module_name;
  final int total_questions;
  final DateTime completed_at;
  final List correct_answers;
  final String? grpId;
  final String? grpName;
  final Map? exam_results;
  final Map? assessments_results;
  UserAssesmentModel({
    this.id,
    this.userId,
    required this.username,
    required this.module_name,
    required this.total_questions,
    required this.completed_at,
    required this.correct_answers,
    this.grpId,
    this.grpName,
    this.exam_results,
    this.assessments_results,
  });

  factory UserAssesmentModel.fromMap(Map<String, dynamic> postMap) {
    return UserAssesmentModel(
      username: postMap["username"] ?? "",
      module_name: postMap["module_name"] ?? "",
      total_questions: postMap["total_questions"] ?? 0,
      completed_at: postMap["completed_at"] != null
          ? DateTime.fromMillisecondsSinceEpoch(postMap["completed_at"])
          : DateTime.now(),
      correct_answers: postMap["corret_answers"] ?? [],
    );
  }
  factory UserAssesmentModel.fromDocumentSnapshot(DocumentSnapshot postMap) {
    return UserAssesmentModel(
      username: (postMap.data() as Map)["username"] ?? "",
      module_name: (postMap.data() as Map)["module_name"] ?? "",
      total_questions: (postMap.data() as Map)["total_questions"] ?? 0,
      completed_at: (postMap.data() as Map)["completed_at"] != null
          ? (postMap.data() as Map)["completed_at"].toDate()
          : DateTime.now(),
      correct_answers: (postMap.data() as Map)["corret_answers"] ?? [0],
    );
  }
}
