// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String address;
  final String department;
  final String education;
  final String email;
  final String firstName;
  final String gender;
  final String lastName;
  final String role;
  final String userGroupId;
  String? grpName;
  UserModel({
    this.id,
    required this.address,
    required this.department,
    required this.education,
    required this.email,
    required this.firstName,
    required this.gender,
    required this.lastName,
    required this.role,
    required this.userGroupId,
    this.grpName,
  });

  factory UserModel.fromMap(Map<String, dynamic> postMap) {
    return UserModel(
        address: postMap["address"] ?? "",
        department: postMap["department"] ?? "",
        education: postMap["education"] ?? "",
        email: postMap["email"] ?? "",
        firstName: postMap["first_name"] ?? "",
        gender: postMap["gender"] ?? "",
        lastName: postMap["last_name"] ?? "",
        role: postMap["user_role"] ?? "",
        userGroupId: postMap["user_group_id"] ?? "");
  }
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot postMap) {
    return UserModel(
      id: postMap.id,
      address: (postMap.data() as Map)["address"] ?? "-",
      department: (postMap.data() as Map)["department"] ?? "-",
      education: (postMap.data() as Map)["education"] ?? "-",
      email: (postMap.data() as Map)["email"] ?? "-",
      firstName: (postMap.data() as Map)["first_name"] ?? "-",
      gender: (postMap.data() as Map)["gender"] ?? "-",
      lastName: (postMap.data() as Map)["last_name"] ?? "-",
      role: (postMap.data() as Map)["user_role"] ?? "-",
      userGroupId: (postMap.data() as Map)["user_group_id"] ?? "-",
    );
  }
}
