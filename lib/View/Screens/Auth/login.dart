import 'package:ame_facedetector/View/Components/util.dart';
import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<void> signInWithEmailAndPassword(context, {
    required String email, required String password
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        ServiceManager().setUser(user.uid);
        ServiceManager().getUserID();
        toastMessage(message: 'Logged In');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => HomePage()), (route) => false);
      } else {
        toastMessage(message: 'Invalid email or password', colors: kRedColor);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      toastMessage(message: removeSquareBrackets('$e'), colors: kRedColor);
      setState(() {
        isLoading = false;
      });
    }
  }

  String removeSquareBrackets(String input) {
    return input.replaceAll(RegExp(r'\[.*?\]'), '');
  }

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
                    KTextField(
                      title: 'Email',
                      controller: email,
                      validate: (value) {
                        if (value == null || value.isEmpty || !value.contains('@') || !value.contains('.')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
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
                    kSpace(),
                    isLoading != true ? KButton(
                      title: 'Continue',
                      onClick: (){
                        if(_formKey.currentState!.validate()){
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));

                          setState(() {
                            isLoading = true;
                          });
                          signInWithEmailAndPassword(
                            context,
                            email: email.text,
                            password: password.text,
                          );

                        }
                      },
                    ) : LoadingButton(),
                    SizedBox(height: 20.0),
                    // RichText(
                    //   textAlign: TextAlign.center,
                    //   text: TextSpan(
                    //     style: TextStyle(color: Colors.black54),
                    //     children: <TextSpan>[
                    //       TextSpan(text: 'Not a registered user ? '),
                    //       TextSpan(
                    //         text: 'Sign up',
                    //         // style: linkTextStyle(),
                    //         recognizer: TapGestureRecognizer()..onTap = () {
                    //           // Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

