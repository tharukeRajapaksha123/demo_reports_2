import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_reports_2/models/course_model.dart';

class CourseController {
  final firebase = FirebaseFirestore.instance;
  Future<List<CourseModel>> fetchCourses() async {
    try {
      List<CourseModel> course = [];
      await firebase.collection("courses").get().then((value) {
        for (DocumentSnapshot snapshot in value.docs) {
          course.add(CourseModel.fromDocumentSnapshot(snapshot));
        }
      });
      return course;
    } catch (e) {
      print("fetch courses failed $e");
      return [];
    }
  }
}
