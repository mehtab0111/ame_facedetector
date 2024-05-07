import 'package:ame_facedetector/View/Screens/splashScreen.dart';
import 'package:ame_facedetector/View/Theme/colors.dart';
import 'package:ame_facedetector/View/Screens/homePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}
