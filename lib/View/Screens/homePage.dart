import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Screens/addEmployee.dart';
import 'package:ame_facedetector/View/Screens/employees.dart';
import 'package:ame_facedetector/View/Screens/transactionsLog.dart';
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
            profileButton(Icons.abc, 'Employee', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Employees()));
            }),
            profileButton(Icons.abc, 'Add Employee', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddEmployee()));
            }),
            profileButton(Icons.abc, 'Transactions Log', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionLog()));
            }),
            // KButton(
            //   onClick: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddEmployee()));
            //   },
            //   title: 'Add Employee',
            // ),
          ],
        ),
      ),
    );
  }
}
