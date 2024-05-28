import 'package:ame_facedetector/Controller/cameraScreen.dart';
import 'package:ame_facedetector/awsconfig.dart';
import 'package:ame_facedetector/View/Screens/splashScreen.dart';
import 'package:ame_facedetector/View/Theme/colors.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Ensure that plugin services are initialized so that `availableCameras()`
  // // can be called before `runApp()`
  // final cameras = await availableCameras();
  // final firstCamera = cameras.first;

  await Firebase.initializeApp();
  initRekognition();
  runApp(const MyApp());
  // runApp(MyApp(camera: firstCamera));
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
      // home: CameraScreen(camera: camera),
    );
  }
}
