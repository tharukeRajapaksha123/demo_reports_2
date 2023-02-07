// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_reports_2/controllers/pdf_controller.dart';
import 'package:demo_reports_2/models/course_model.dart';
import 'package:flutter/material.dart';

import 'package:demo_reports_2/controllers/user_controller.dart';
import 'package:demo_reports_2/models/user_assesment.dart';

class UserAssesementView extends StatefulWidget {
  final String groupId;
  final List<CourseModel> courses;
  const UserAssesementView({
    Key? key,
    required this.groupId,
    required this.courses,
  }) : super(key: key);

  @override
  State<UserAssesementView> createState() => _UserAssesementViewState();
}

class _UserAssesementViewState extends State<UserAssesementView> {
  bool load = false;
  List<UserAssesmentModel> assesments = [];
  List<UserAssesmentModel> tassesments = [];
  List<DataColumn> columns = [];
  List<DataRow> raws = [];
  List<String> modules = [];
  String selected = "";
  List<String> columnNames = [];
  List<Map> tableData = [];
  Future<void> setData() async {
    setState(() {
      load = !load;
    });
    List<UserAssesmentModel> as =
        await UserController().fetchUserAssesmentData();
    setState(() {
      assesments = as;
      tassesments = as;
      for (UserAssesmentModel ass in as) {
        modules.add(ass.module_name.toLowerCase());
      }
      modules = modules.toSet().toList();
    });
    setColumns();
    setState(() {
      load = !load;
    });
  }

  @override
  void initState() {
    setData().then((value) => filterData()).then((value) => setRows());
    super.initState();
  }

  void filterData() {
    if (widget.groupId != "all") {
      setState(() {
        assesments = tassesments
            .where((element) => element.grpId == widget.groupId)
            .toList();
      });
    }
  }

  void setColumns() {
    setState(() {
      columns.add(const DataColumn(
        label: Text(""),
      ));
      columnNames.add("");
      columns.add(const DataColumn(
        label: Text("USERNAME"),
      ));
      columnNames.add("USERNAMES");
      columns.add(const DataColumn(
        label: Text("GROUP"),
      ));
      columnNames.add("GROUP");
      for (String module in modules) {
        columns.add(DataColumn(label: Text(module.toUpperCase())));
        columnNames.add(module);
      }
      columns.add(const DataColumn(label: Text("AVERAGE")));
      columnNames.add("AVERAGE");
    });
  }

  void setRows() async {
    raws.clear();
    List<String> ids = [];
    for (UserAssesmentModel assesmentModel in assesments) {
      if (!ids.contains(assesmentModel.username)) {
        ids.add(assesmentModel.username);
      }
    }
    List<Map> ms = [];
    await FirebaseFirestore.instance.collection("modules").get().then((value) {
      for (DocumentSnapshot snapshot in value.docs) {
        ms.add({"id": snapshot.id, "name": (snapshot.data() as Map)["name"]});
      }
    });

    setState(() {
      int inv = 1;
      for (String id in ids) {
        Map map = {};
        List<DataCell> cells = [];

        map[0] = inv.toString();

        cells.add(DataCell(Text(inv.toString())));
        map[1] = id;

        cells.add(DataCell(Text(id)));
        List<UserAssesmentModel> ass =
            assesments.where((element) => element.username == id).toList();

        int i = ass.indexWhere((element) => element.username == id);
        cells.add(DataCell(Text(ass[i].grpName!)));
        map[2] = ass[i].grpName!;
        double t = 0;
        int counter = 3;
        for (String module in modules) {
          int index = ass.indexWhere((element) {
            return module.toLowerCase().trim() ==
                element.module_name.toLowerCase().trim();
          }).toInt();
          int i = ms.indexWhere((element) {
            return element["name"].toLowerCase() == module.toLowerCase();
          });
          if ((i != -1) && (index != -1)) {
            String id = ms[i]["id"];
            cells.add(DataCell(Text(ass[index].exam_results![id].toString())));
            map[counter] = ass[index].exam_results![id].toString();
            t += ass[index].exam_results![id];
          } else {
            cells.add(const DataCell(
              Text("-"),
            ));
            map[counter] = "-";
          }

          // if (index != -1) {
          //   int max = -1;
          //   for (int correct in ass[index].correct_answers) {
          //     if (correct > max) {
          //       max = correct;
          //     }
          //   }
          //   double average = (max / ass[index].total_questions) * 100;
          //   t += average;
          //   cells.add(
          //     DataCell(
          //       Text(
          //         "${average.toStringAsFixed(2)} %",
          //       ),
          //     ),
          //   );
          // } else {
          //   cells.add(const DataCell(
          //     Text("-"),
          //   ));
          // }
          counter++;
        }

        cells.add(
          DataCell(
            Text("${(t / modules.length).toStringAsFixed(2)} %"),
          ),
        );
        map[counter] = (t / modules.length).toStringAsFixed(2);
        raws.add(DataRow(cells: cells));
        inv++;
        tableData.add(map);
      }
    });
  }

  void filterByModuleName(String name, String id) async {
    List moduleNames = [];
    CourseModel course =
        widget.courses.where((element) => element.id! == id).toList().first;
    for (String id in course.moudle_ids) {
      await FirebaseFirestore.instance
          .collection("modules")
          .doc(id)
          .get()
          .then((value) {
        if (value.exists) {
          moduleNames.add((value.data() as Map)["name"].toLowerCase());
        }
      });
    }

    setState(() {
      selected = name;
      assesments = tassesments
          .where(
            (element) => moduleNames.contains(
              element.module_name.toLowerCase(),
            ),
          )
          .toList();
    });
    setRows();
  }

  void reset() {
    setState(() {
      selected = "";
      assesments = tassesments;
    });
    setRows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Assesments",
        ),
        actions: [
          IconButton(
            onPressed: () {
              PdfController().exportExam(tableData, columnNames);
            },
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: load
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  height: kToolbarHeight,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    ...widget.courses
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: MaterialButton(
                                color: selected == e.name
                                    ? Colors.lightBlue
                                    : Colors.amber,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                onPressed: () {
                                  filterByModuleName(e.name, e.id!);
                                },
                                child: Text(
                                  e.name,
                                ),
                              ),
                            ))
                        .toList(),
                    MaterialButton(
                      color: selected == "" ? Colors.lightBlue : Colors.amber,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      onPressed: () {
                        reset();
                      },
                      child: const Text(
                        "Reset",
                      ),
                    )
                  ]),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(columns: columns, rows: raws),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
