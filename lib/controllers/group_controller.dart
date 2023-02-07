import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_reports_2/models/user_group_model.dart';

class GroupController {
  final firebase = FirebaseFirestore.instance;

  Future<List<UserGroupModel>> fetchUsers() async {
    try {
      List<UserGroupModel> groups = [];
      await firebase.collection("userGroups").get().then((value) {
        for (DocumentSnapshot snapshot in value.docs) {
          groups.add(UserGroupModel.fromDocumentSnapshot(snapshot));
        }
      });
      return groups;
    } catch (e) {
      print("fetch users failed $e");
      return [];
    }
  }
}
