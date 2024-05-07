import 'dart:async';
import 'package:ame_facedetector/Controller/serviceManager.dart';
import 'package:ame_facedetector/View/Screens/homePage.dart';
import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    ServiceManager().getUserID();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if(ServiceManager.userID != ''){
        // ServiceManager().getUserData();
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        //     builder: (context) => NavigationScreen()), (route) => false);
      } else {
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (_) => Login()));
      }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomePage()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer!.isActive) _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('images/app_logo.png', height: 200),
      ),
    );
  }
}
