import 'dart:io';

import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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


  // File? _image;
  // final picker = ImagePicker();
  // final _s3Client = S3(region: 'your-region', credentials: AwsClientCredentials(accessKey: 'your-access-key', secretKey: 'your-secret-key'));
  // final _rekognitionClient = Rekognition(region: 'your-region', credentials: AwsClientCredentials(accessKey: 'your-access-key', secretKey: 'your-secret-key'));
  //
  // Future getImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }
  //
  // Future<void> uploadImageToS3(File image) async {
  //   final bucketName = 'your-bucket-name';
  //   final key = 'your-image-key.jpg';
  //
  //   try {
  //     final bytes = await image.readAsBytes();
  //     await _s3Client.putObject(
  //       bucket: bucketName,
  //       key: key,
  //       body: bytes,
  //       contentLength: bytes.length,
  //     );
  //     print('Upload successful');
  //   } catch (e) {
  //     print('Upload failed: $e');
  //   }
  // }
  //
  // Future<void> detectLabels(String bucket, String key) async {
  //   try {
  //     final result = await _rekognitionClient.detectLabels(
  //       image: rekognition.Image(s3Object: rekognition.S3Object(bucket: bucket, name: key)),
  //     );
  //
  //     result.labels!.forEach((label) {
  //       print('${label.name}: ${label.confidence}');
  //     });
  //   } catch (e) {
  //     print('Label detection failed: $e');
  //   }
  // }

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
