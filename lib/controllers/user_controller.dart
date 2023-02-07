//fetch user details
//fetch user exam details
//fetch user asssesments
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_reports_2/models/user_assesment.dart';
import 'package:demo_reports_2/models/user_exam.dart';
import 'package:demo_reports_2/models/user_model.dart';

class UserController {
  final firebase = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchUserData() async {
    try {
      List<UserModel> users = [];
      await firebase.collection("users").get().then((value) async {
        for (DocumentSnapshot snapshot in value.docs) {
          UserModel user = UserModel.fromDocumentSnapshot(snapshot);
          await firebase
              .collection("userGroups")
              .doc(user.userGroupId)
              .get()
              .then((value) {
            if (value.exists) {
              user.grpName = (value.data() as Map)["title"];
            }
          });
          users.add(user);
        }
      });
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserAssesmentModel>> fetchUserExamData() async {
    print("casdadsada");
    try {
      List<UserAssesmentModel> users = [];
      await firebase.collection("users").get().then((value) async {
        for (DocumentSnapshot sn in value.docs) {
          String gName = "-";
          await firebase
              .collection("userGroups")
              .doc((sn.data() as Map)["user_group_id"])
              .get()
              .then((value) {
            if (value.exists) {
              gName = (value.data() as Map)["title"];
            }
          });
          await firebase
              .collection("users")
              .doc(sn.id)
              .collection("examResults")
              .get()
              .then((value) {
            for (DocumentSnapshot snapshot in value.docs) {
              try {
                UserAssesmentModel assesmentModel = UserAssesmentModel(
                    id: snapshot.id,
                    userId: sn.id,
                    username: (sn.data() as Map)["email"],
                    module_name: (snapshot.data() as Map)["module_name"],
                    total_questions:
                        (snapshot.data() as Map)["total_questions"],
                    completed_at:
                        (snapshot.data() as Map)["completed_at"].toDate(),
                    correct_answers:
                        (snapshot.data() as Map)["corret_answers"] ?? [],
                    grpId: (sn.data() as Map)["user_group_id"],
                    grpName: gName,
                    assessments_results:
                        (sn.data() as Map)["assessment_results"],
                    exam_results: (sn.data() as Map)["exam_results"]);

                users.add(assesmentModel);
              } catch (e) {
                print("model convert failed $e");
              }
            }
          });
        }
      });
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserAssesmentModel>> fetchUserAssesmentData() async {
    try {
      List<UserAssesmentModel> users = [];
      await firebase.collection("users").get().then((value) async {
        for (DocumentSnapshot sn in value.docs) {
          String gName = "-";
          await firebase
              .collection("userGroups")
              .doc((sn.data() as Map)["user_group_id"])
              .get()
              .then((value) {
            if (value.exists) {
              gName = (value.data() as Map)["title"];
            }
          });
          await firebase
              .collection("users")
              .doc(sn.id)
              .collection("assessmentResults")
              .get()
              .then((value) {
            for (DocumentSnapshot snapshot in value.docs) {
              try {
                UserAssesmentModel assesmentModel = UserAssesmentModel(
                    id: snapshot.id,
                    userId: sn.id,
                    username: (sn.data() as Map)["email"],
                    module_name: (snapshot.data() as Map)["module_name"],
                    total_questions:
                        (snapshot.data() as Map)["total_questions"],
                    completed_at:
                        (snapshot.data() as Map)["completed_at"].toDate(),
                    correct_answers:
                        (snapshot.data() as Map)["corret_answers"] ?? [],
                    grpId: (sn.data() as Map)["user_group_id"],
                    grpName: gName,
                    assessments_results:
                        (sn.data() as Map)["assessment_results"],
                    exam_results: (sn.data() as Map)["exam_results"]);
                users.add(assesmentModel);
              } catch (e) {
                print("model convert failed $e");
              }
            }
          });
        }
      });
      return users;
    } catch (e) {
      return [];
    }
  }
}
