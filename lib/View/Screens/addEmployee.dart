import 'dart:io';

import 'package:ame_facedetector/Controller/serviceManager.dart';
import 'package:ame_facedetector/View/Components/DialogueBox/imagePickerPopUp.dart';
import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:ame_facedetector/View/Components/util.dart';
import 'package:ame_facedetector/View/Theme/colors.dart';
import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController employeeName = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  // TextEditingController cardNumber = TextEditingController();
  // TextEditingController serialNumber = TextEditingController();
  // TextEditingController userName = TextEditingController();
  // TextEditingController userPassword = TextEditingController();
  // TextEditingController commandID = TextEditingController();

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  File? _image;
  void pickImageFromGallery() async {
    var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  void pickImageFromCamera() async {
    var pickedImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

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
              kSpace(),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundColor:Theme.of(context).scaffoldBackgroundColor != Colors.black ?
                    Colors.white : kDarkColor,
                    child: _image != null ? CircleAvatar(
                      radius: 70,
                      backgroundImage: FileImage(File(_image!.path)),
                    ) : CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('images/img_blank_profile.png'),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.6),
                      radius: 20,
                      child: IconButton(
                        icon: Icon(Icons.edit_outlined),
                        color: Colors.white,
                        onPressed: (){
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context){
                              return ImagePickerPopUp(
                                onCameraClick: (){
                                  Navigator.pop(context);
                                  pickImageFromCamera();
                                },
                                onGalleryClick: (){
                                  Navigator.pop(context);
                                  pickImageFromGallery();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              kSpace(),
              SizedBox(height: 5),
              // KTextField(
              //   title: 'Employee Code',
              //   controller: employeeCode,
              // ),
              KTextField(
                title: 'Employee Name',
                controller: employeeName,
              ),
              KTextField(
                title: 'Employee Mobile',
                controller: mobile,
                textInputType: TextInputType.number,
                textLimit: 10,
              ),
              KTextField(
                title: 'Employee Email',
                controller: email,
                textInputType: TextInputType.emailAddress,
                validate: (value) {
                  if (value == null || value.isEmpty || !value.contains('@') || !value.contains('.')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              isLoading != true ? KButton(
                title: 'Save',
                onClick: (){
                  if(_formKey.currentState!.validate()){
                    if(_image != null){
                      setState(() {
                        isLoading = true;
                      });
                      addEmployeeData(context);
                    } else {
                      toastMessage(message: 'Upload Image');
                    }

                  }
                },
              ) : LoadingButton(),
              kBottomSpace(),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> addEmployeeData(context) async {
    try{
      String imagePath = await ServiceManager().uploadImage(_image!.path, 'employee');

      _firestore.collection('employee').add({
        'email': email.text,
        'image': imagePath,
        'mobile': mobile.text,
        'name': employeeName.text,
        'createdAt': DateTime.now(),
      });
    } catch (e){
      print(e);
      setState(() {
        isLoading = false;
      });
    }
    toastMessage(message: 'Employee Added');
    Navigator.pop(context);
    return 'Success';
  }
}
