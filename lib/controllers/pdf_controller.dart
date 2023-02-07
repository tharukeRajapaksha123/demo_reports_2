import 'package:demo_reports_2/models/user_assesment.dart';
import 'package:demo_reports_2/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';

class PdfController {
  Future<void> exportPdf(List<UserModel> users) async {
    try {
      final pdf = pw.Document();
      int counter = 0;
      pdf.addPage(
        MultiPage(
          build: (context) => [
            Table.fromTextArray(context: context, data: <List<String>>[
              <String>[
                "",
                'First Name',
                'Last Name',
                "GROUP",
                'Gender',
                'Email',
                'User Type',
                'Department',
                'Education',
                'Address',
              ],
              ...users.map(
                (e) {
                  counter++;
                  return [
                    counter.toString(),
                    e.firstName,
                    e.lastName,
                    e.grpName ?? "",
                    e.gender,
                    e.email,
                    e.role,
                    e.department,
                    e.education,
                    e.address,
                  ];
                },
              ).toList(),
            ]),
          ],
        ),
      );

      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final file = File("${appDocDirectory.path}/$fileName.pdf");

      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);
    } catch (e) {
      print("Export pdf failed $e");
    }
  }

  Future<void> exportAssessmentPdf(List<UserModel> users) async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        MultiPage(
          build: (context) => [
            Table.fromTextArray(context: context, data: <List<String>>[
              <String>[
                'Address',
                'Department',
                'Education',
                'Email',
                'First Name',
                'Last Name',
                'Gender',
                'User Role',
              ],
              ...users
                  .map(
                    (e) => [
                      e.address,
                      e.department,
                      e.education,
                      e.email,
                      e.firstName,
                      e.lastName,
                      e.gender,
                      e.role,
                    ],
                  )
                  .toList(),
            ]),
          ],
        ),
      );

      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final file = File("${appDocDirectory.path}/$fileName.pdf");

      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);
    } catch (e) {
      print("Export pdf failed $e");
    }
  }

  Future<void> exportExam(
      List<Map> assesments, List<String> columnNames) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        MultiPage(
          build: (context) => [
            Table.fromTextArray(
              context: context,
              headers: columnNames,
              data: [
                ...assesments
                    .map(
                      (Map e) => List.generate(
                        e.length,
                        (index) {
                          return e[index];
                        },
                      ),
                    )
                    .toList()
              ],
            ),
          ],
        ),
      );

      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final file = File("${appDocDirectory.path}/$fileName.pdf");

      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);
    } catch (e) {
      print("Export pdf failed $e");
    }
  }
}
