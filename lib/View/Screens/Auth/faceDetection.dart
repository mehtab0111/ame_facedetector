// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';
//
// class FaceDetectionPage extends StatefulWidget {
//   @override
//   _FaceDetectionPageState createState() => _FaceDetectionPageState();
// }
//
// class _FaceDetectionPageState extends State<FaceDetectionPage> {
//
//   File? _imageFile;
//   List<Face> _faces = [];
//
//   Future<void> _getImageAndDetectFaces() async {
//     final imagePicker = ImagePicker();
//     final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile == null) return;
//
//     final File imageFile = File(pickedFile.path);
//     final imageSize = await _getImageSize(imageFile);
//
//     setState(() {
//       _imageFile = imageFile;
//     });
//   }
//
//   Future<Size> _getImageSize(File imageFile) async {
//     final bytes = await imageFile.readAsBytes();
//     final image = await decodeImageFromList(Uint8List.fromList(bytes));
//     return Size(image.width.toDouble(), image.height.toDouble());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Face Detection'),
//       ),
//       body: Center(
//         child: _imageFile == null ? Text('No image selected.') : FittedBox(
//           child: SizedBox(
//             // width: _imageFile!.width.toDouble(),
//             // height: _imageFile!.height.toDouble(),
//             height: 300,
//             width: 400,
//             child: CustomPaint(
//               painter: FacePainter(_imageFile!, _faces),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _getImageAndDetectFaces,
//         tooltip: 'Pick Image',
//         child: Icon(Icons.add_a_photo),
//       ),
//     );
//   }
// }
//
// class FacePainter extends CustomPainter {
//   final File imageFile;
//   final List<Face> faces;
//
//   FacePainter(this.imageFile, this.faces);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0
//       ..color = Colors.red;
//
//     // final imageSize = Size(imageFile.width.toDouble(), imageFile.height.toDouble());
//     final imageSize = Size(100, 100);
//     final scaleX = size.width / imageSize.width;
//     final scaleY = size.height / imageSize.height;
//
//     for (var i = 0; i < faces.length; i++) {
//       final face = faces[i];
//       final rect = Rect.fromLTRB(
//         face.boundingBox.left * scaleX,
//         face.boundingBox.top * scaleY,
//         face.boundingBox.right * scaleX,
//         face.boundingBox.bottom * scaleY,
//       );
//       canvas.drawRect(rect, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
