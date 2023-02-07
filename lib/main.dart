import 'package:demo_reports_2/views/group_view.dart';
import 'package:demo_reports_2/views/user_assesments_view.dart';
import 'package:demo_reports_2/views/user_details_view.dart';
import 'package:demo_reports_2/views/user_exams_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Spacer(),
            materialButton("User Details", 0),
            materialButton("User Exams", 1),
            materialButton("User Assessments", 2),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget materialButton(String name, int index) => Padding(
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
                builder: ((context) => GroupView(
                      index: index,
                    )),
              ),
            );
          },
          child: Text(
            name,
          ),
        ),
      );
}
