import 'package:flutter/material.dart';
import 'package:demo_reports_2/controllers/pdf_controller.dart';
import 'package:demo_reports_2/controllers/user_controller.dart';
import 'package:demo_reports_2/models/course_model.dart';
import 'package:demo_reports_2/models/user_model.dart';

class UserDetailsView extends StatefulWidget {
  final String groupId;
  final List<CourseModel> courses;
  const UserDetailsView({
    Key? key,
    required this.groupId,
    required this.courses,
  }) : super(key: key);

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  List<UserModel> users = [];
  List<UserModel> tUsers = [];
  String groupId = "";
  bool shouldLoad = false;
  @override
  void initState() {
    setState(() {
      groupId = widget.groupId;
    });
    setData().then((value) => filterData());
    super.initState();
  }

  Future<void> setData() async {
    setState(() {
      shouldLoad = true;
    });
    List<UserModel> u = await UserController().fetchUserData();
    setState(() {
      users = u;
      tUsers = u;
      shouldLoad = false;
    });
  }

  void filterData() {
    if (widget.groupId != "all") {
      users =
          tUsers.where((element) => element.userGroupId == groupId).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Report"),
        actions: [
          IconButton(
            onPressed: () async {
              PdfController().exportPdf(users);
            },
            icon: const Icon(
              Icons.upload,
            ),
          ),
        ],
      ),
      body: shouldLoad
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : Container(
              padding: const EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height,
              //  width: MediaQuery.of(context).size.width * 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(""),
                      ),
                      DataColumn(
                        label: Text("First Name"),
                      ),
                      DataColumn(
                        label: Text("Last Name"),
                      ),
                      DataColumn(
                        label: Text("Group"),
                      ),
                      DataColumn(
                        label: Text("Gender"),
                      ),
                      DataColumn(
                        label: Text("Email"),
                      ),
                      DataColumn(
                        label: Text("User Type"),
                      ),
                      DataColumn(
                        label: Text("Department"),
                      ),
                      DataColumn(
                        label: Text("Education"),
                      ),
                      DataColumn(
                        label: Text("Address"),
                      ),
                    ],
                    rows: users.map((e) {
                      counter++;
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(counter.toString()),
                          ),
                          DataCell(
                            Text(e.firstName),
                          ),
                          DataCell(
                            Text(e.lastName),
                          ),
                          DataCell(
                            Text(e.grpName!),
                          ),
                          DataCell(
                            Text(e.gender),
                          ),
                          DataCell(
                            Text(e.email),
                          ),
                          const DataCell(
                            Text("PARTICIPANT"),
                          ),
                          DataCell(
                            Text(e.department),
                          ),
                          DataCell(
                            Text(e.education),
                          ),
                          DataCell(
                            Text(e.address),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
}
