import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionLog extends StatefulWidget {
  const TransactionLog({super.key});

  @override
  State<TransactionLog> createState() => _TransactionLogState();
}

class _TransactionLogState extends State<TransactionLog> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController serialNumber = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  TextEditingController strDataList = TextEditingController();

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, int type) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      if(type == 1){
        setState(() {
          selectedDate = picked;
          fromDate.text = '${picked.day}/${picked.month}/${picked.year}';
        });
      } else {
        setState(() {
          selectedDate = picked;
          toDate.text = '${picked.day}/${picked.month}/${picked.year}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Transaction Log'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 5),
              KTextField(
                title: 'From Date',
                controller: fromDate,
                readOnly: true,
                onClick: (){
                  _selectDate(context, 1);
                },
                suffixButton: Icon(Icons.calendar_month_outlined),
              ),
              KTextField(
                title: 'To Date',
                controller: toDate,
                readOnly: true,
                onClick: (){
                  _selectDate(context, 2);
                },
                suffixButton: Icon(Icons.calendar_month_outlined),
              ),
              KTextField(title: 'Serial Number', controller: serialNumber,),
              KTextField(title: 'User Name', controller: userName,),
              KTextField(title: 'User Password', controller: userPassword,),
              KTextField(title: 'str DataList', controller: strDataList,),
              KButton(
                title: 'Save',
                onClick: (){
                  if(_formKey.currentState!.validate()){

                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getTransactionLog() async {
    String url = 'http://111.93.157.53/iclock/WebAPIService.asmx?op=GetTransactionsLog';
    var response = await http.post(Uri.parse(url), body: {
      'FromDate': '',
      'ToDate': '',
      'SerialNumber': serialNumber.text,
      'UserName': userName.text,
      'UserPassword': userPassword.text,
      'strDataList': strDataList.text,
    });
    if(response.statusCode == 200){

    }
  }
}
