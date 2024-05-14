import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Screens/Auth/faceDetection.dart';
import 'package:ame_facedetector/View/Screens/addEmployee.dart';
import 'package:ame_facedetector/View/Screens/employees.dart';
import 'package:ame_facedetector/View/Screens/transactionsLog.dart';
import 'package:ame_facedetector/View/Screens/commandStatus.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Face Detector'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Row(),
            SizedBox(height: 5),
            KButton(
              title: 'Clock In Employee',
              onClick: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => FaceDetectionPage()));
              },
            ),
            profileButton(Icons.badge_outlined, 'Employee', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Employees()));
            }),
            profileButton(Icons.person_add_outlined, 'Add Employee', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddEmployee()));
            }),
            profileButton(Icons.gavel_outlined, 'Command Status', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CommandStatus()));
            }),
            profileButton(Icons.receipt_long_outlined, 'Transactions Log', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionLog()));
            }),
          ],
        ),
      ),
    );
  }
}
