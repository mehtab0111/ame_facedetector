import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommandStatus extends StatefulWidget {
  const CommandStatus({super.key});

  @override
  State<CommandStatus> createState() => _CommandStatusState();
}

class _CommandStatusState extends State<CommandStatus> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController commandID = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Command Status'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 5),
              KTextField(title: 'CommandId', controller: commandID,),
              KTextField(title: 'UserName', controller: userName,),
              KTextField(title: 'UserPassword', controller: userPassword,),
              KButton(
                title: 'Save',
                onClick: (){
                  if(_formKey.currentState!.validate()){

                  }
                },
              ),
            ],
          ),
        )
      ),
    );
  }

  void getCommandStatus() async {
    String url = 'http://111.93.157.53/iclock/WebAPIService.asmx?op=GetTransactionsLog';
    var response = await http.post(Uri.parse(url), body: {
      'CommandId': commandID.text,
      'UserName': userName.text,
      'UserPassword': userPassword.text,
    });
    if(response.statusCode == 200){

    }
  }
}
