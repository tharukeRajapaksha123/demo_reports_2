// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo_reports_2/controllers/course_controller.dart';
import 'package:demo_reports_2/models/course_model.dart';
import 'package:demo_reports_2/views/user_assesments_view.dart';
import 'package:demo_reports_2/views/user_exams_view.dart';
import 'package:flutter/material.dart';

import 'package:demo_reports_2/controllers/group_controller.dart';
import 'package:demo_reports_2/models/user_group_model.dart';
import 'package:demo_reports_2/views/user_details_view.dart';

class GroupView extends StatefulWidget {
  final int index;
  const GroupView({
    Key? key,
    this.index = 0,
  }) : super(key: key);

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  List<CourseModel> courses = [];

  @override
  void initState() {
    CourseController().fetchCourses().then((value) => setState(() {
          courses = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
            future: GroupController().fetchUsers(),
            builder: (context, AsyncSnapshot<List<UserGroupModel>> snapshot) {
              return !snapshot.hasData
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    )
                  : snapshot.data!.isEmpty
                      ? const Center(
                          child: Text("Np grpu[s available"),
                        )
                      : Column(
                          children: [
                            const Spacer(),
                            materialButton(
                                "Overall",
                                widget.index == 0
                                    ? UserDetailsView(
                                        groupId: "all",
                                        courses: courses,
                                      )
                                    : widget.index == 1
                                        ? UserExamsView(
                                            grpId: "all",
                                            courses: courses,
                                          )
                                        : UserAssesementView(
                                            groupId: "all",
                                            courses: courses,
                                          ),
                                context),
                            ...snapshot.data!
                                .map((e) => materialButton(
                                    e.title,
                                    widget.index == 0
                                        ? UserDetailsView(
                                            groupId: e.id!,
                                            courses: courses,
                                          )
                                        : widget.index == 1
                                            ? UserExamsView(
                                                grpId: e.id!,
                                                courses: courses,
                                              )
                                            : UserAssesementView(
                                                groupId: e.id!,
                                                courses: courses,
                                              ),
                                    context))
                                .toList(),
                            const Spacer(),
                          ],
                        );
            }),
      ),
    );
  }

  Widget materialButton(String name, Widget widget, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width / 1.2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          height: kToolbarHeight,
          color: Colors.lightGreen,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => widget),
              ),
            );
          },
          child: Text(
            name,
          ),
        ),
      );
}
