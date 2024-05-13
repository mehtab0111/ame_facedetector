import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ame_facedetector/Controller/serviceManager.dart';
import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Theme/colors.dart';
import 'package:ame_facedetector/View/Screens/homePage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool buttonEnabled = false;
  bool textObscure = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: kBackgroundDesign(context),
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Image.asset('images/app_logo.png'),
              ),
              SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    KTextField(title: 'Email', controller: email,),
                    KTextField(
                      title: 'Password',
                      controller: password,
                      obscureText: textObscure,
                      suffixButton: IconButton(
                        onPressed: (){
                          setState(() {
                            textObscure = !textObscure;
                          });
                        },
                        icon: Icon(textObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      ),
                    ),
                    // SizedBox(height: 20.0),
                    TextButton(
                      onPressed: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
                      },
                      child: Text('Forget Password?',
                        style: TextStyle(color: kRedColor),
                      ),
                    ),
                    // if(buttonEnabled)
                    isLoading != true ? KButton(
                      title: 'Continue',
                      onClick: (){
                        if(_formKey.currentState!.validate()){
                          // setState(() {
                          //   isLoading = true;
                          // });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        }
                      },
                    ) : LoadingButton(),
                    SizedBox(height: 20.0),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black54),
                        children: <TextSpan>[
                          TextSpan(text: 'Not a registered user ? '),
                          TextSpan(
                            text: 'Sign up',
                            // style: linkTextStyle(),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(width: 1),
          ),
          child: MaterialButton(
            minWidth: 70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: (){
              setState(() {
                // ServiceManager.userID = '';
                // ServiceManager.userName = '';
                // ServiceManager.profileURL = '';
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Text('Skip'),
          ),
        ),
      ),
    );
  }
}

