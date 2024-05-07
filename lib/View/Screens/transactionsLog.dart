import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Log'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              KTextField(title: 'FromDate', controller: fromDate),
              KTextField(title: 'ToDate', controller: toDate,),
              KTextField(title: 'SerialNumber', controller: serialNumber,),
              KTextField(title: 'UserName', controller: userName,),
              KTextField(title: 'UserPassword', controller: userPassword,),
              KTextField(title: 'strDataList', controller: strDataList,),
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
}
