// import 'dart:io';
// import 'package:ame_facedetector/View/Components/DialogueBox/imagePickerPopUp.dart';
// import 'package:ame_facedetector/View/Components/buttons.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image_picker/image_picker.dart';
//
// class FaceRecognize extends StatefulWidget {
//   @override
//   _FaceRecognizeState createState() => _FaceRecognizeState();
// }
//
// class _FaceRecognizeState extends State<FaceRecognize> {
//
//   final ImagePicker _picker = ImagePicker();
//   File? _image;
//   void pickImageFromGallery() async {
//     var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = File(pickedImage!.path);
//     });
//     doFaceDetection();
//   }
//
//   void pickImageFromCamera() async {
//     var pickedImage = await _picker.pickImage(source: ImageSource.camera);
//     setState(() {
//       _image = File(pickedImage!.path);
//     });
//     doFaceDetection();
//   }
//
//   late FaceDetector faceDetector;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     final options = FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
//     faceDetector = FaceDetector(options: options);
//   }
//
//   List<Face> faces = [];
//
//   List<UserFaces> react = [
//     UserFaces(
//       userID: '1',
//       react: Rect.fromLTRB(570.0, 86.0, 610.0, 138.0),
//       userName: 'Debjani',
//     ),
//     UserFaces(
//       userID: '1',
//       react: Rect.fromLTRB(210.0, 61.0, 316.0, 202.0),
//       userName: 'Demo Face',
//     ),
//     UserFaces(
//       userID: '1',
//       react: Rect.fromLTRB(566.0, 763.0, 1367.0, 1816.0),
//       userName: 'Mehtab',
//     ),
//   ];
//
//   String userName = '';
//   String rectCode = '';
//   doFaceDetection() async {
//
//     InputImage inputImage = InputImage.fromFile(_image!);
//     print(inputImage.filePath);
//     faces = await faceDetector.processImage(inputImage);
//
//     print("${faces}");
//
//     bool matchFound = false;
//     for (Face face in faces) {
//       final Rect boundingBox = face.boundingBox;
//       print("Rect = $boundingBox");
//       rectCode = boundingBox.toString();
//
//       matchFound = react.any((element) => element.react == boundingBox);
//       if (matchFound) {
//         setState(() {
//           userName = react.firstWhere((element) => element.react == boundingBox).userName;
//           rectCode = react.firstWhere((element) => element.react == boundingBox).react.toString();
//         });
//         break; // Exit the loop if a match is found
//       }
//     }
//
//     if (!matchFound) {
//       setState(() {
//         userName = 'No user with similar face found';
//       });
//     }
//
//     print("$faces");
//
//   }
//
//   @override
//   void dispose() {
//     faceDetector.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Face Detection'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(),
//             if(_image != null)
//             Container(
//               child: Image.file(File(_image!.path)),
//             ),
//             Text(userName),
//             Text(rectCode),
//             KButton(
//               title: 'Upload Image',
//               onClick: (){
//                 showModalBottomSheet(
//                   context: context,
//                   builder: (context){
//                     return ImagePickerPopUp(
//                       onCameraClick: (){
//                         Navigator.pop(context);
//                         pickImageFromCamera();
//                       },
//                       onGalleryClick: (){
//                         Navigator.pop(context);
//                         pickImageFromGallery();
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class UserFaces {
//   String userID;
//   Rect react;
//   String userName;
//   UserFaces({required this.userID ,required this.react, required this.userName});
// }
