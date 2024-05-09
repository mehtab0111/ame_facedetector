import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController employeeCode = TextEditingController();
  TextEditingController employeeName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController serialNumber = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  TextEditingController commandID = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Add Employee'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 5),
              KTextField(
                title: 'Employee Code',
                controller: employeeCode,
              ),
              KTextField(
                title: 'Employee Name',
                controller: employeeName,
              ),
              KTextField(
                title: 'Card Number',
                controller: cardNumber,
              ),
              KTextField(
                title: 'Serial Number',
                controller: serialNumber,
              ),
              KTextField(
                title: 'User Name',
                controller: userName,
              ),
              KTextField(
                title: 'User Password',
                controller: userPassword,
              ),
              KTextField(
                title: 'Command Id',
                controller: commandID,
              ),
              KButton(
                title: 'Save',
                onClick: (){
                  if(_formKey.currentState!.validate()){
                    addEmployeeData();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> addEmployeeData() async {
    String url = 'http://192.168.1.140/iclock/WebAPIService.asmx?op=AddEmployee';
    var response = await http.post(Uri.parse(url), body: {

    });
    if(response.statusCode == 200){
      print(response.body);
    } else {
      print(response.body);
    }
    return 'Success';
  }
}
