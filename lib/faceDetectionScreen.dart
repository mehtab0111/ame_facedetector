import 'dart:io';
import 'package:ame_facedetector/Model/user_model.dart';
import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Components/kDatabase.dart';
import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:ame_facedetector/awsconfig.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectionScreen extends StatefulWidget {
  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {

  // Users? selectedUser;
  String employeeValue = '';
  String employeeImage = '';
  String employeeName = '';
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  File? _image;

  double matchPercentage = 0.0;
  Future<void> _pickImage() async {
    setState(() {
      isLoading = true;
    });
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // await detectFaces(pickedFile.path);
      // await detectLabels(pickedFile.path);
      // compareFaces(pickedFile.path, pickedFile.path);

      matchPercentage = await compareFaces(employeeImage, pickedFile.path);
      setState(() {
        _image = File(pickedFile.path);
      });
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Employee Attendance'),
        // actions: [
        //   TextButton(
        //     onPressed: (){
        //       listFaceCollections();
        //     },
        //     child: Text('Test Data'),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Select Employee'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: dropTextFieldDesign(context),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10.0),
                      value: employeeValue != '' ? employeeValue : null,
                      hint: Text('Select State', style: hintTextStyle(context)),
                      items: userList
                          .map<DropdownMenuItem>((value) {
                        return DropdownMenuItem(
                          value: value.userID,
                          child: Text(value.userName),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          employeeValue = newValue;
                          employeeImage = userList.firstWhere((user) => user.userID == newValue).image;
                          employeeName = userList.firstWhere((user) => user.userID == newValue).userName;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (employeeName != '')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.network(
                      employeeImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10),
                    Text(employeeName),
                  ],
                ),
              ),
            kSpace(),
            if(_image != null)
            Image.file(File(_image!.path), height: 200,),
            if(employeeName != '')
            matchPercentage > 90 ?
            Column(
              children: [
                Text('Match Result: $matchPercentage'),
                Text('You are logged in'),
              ],
            ) : Text("Scan a proper image"),
            kSpace(),
            if(employeeName != '')
            KButton(
              onClick: _pickImage,
              title: 'Scan Image',
            ),
          ],
        ),
      ),
    );
  }
}
