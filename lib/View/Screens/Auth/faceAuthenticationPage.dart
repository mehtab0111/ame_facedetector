import 'dart:io';
import 'package:ame_facedetector/View/Components/DialogueBox/imagePickerPopUp.dart';
import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceRecognize extends StatefulWidget {
  @override
  _FaceRecognizeState createState() => _FaceRecognizeState();
}

class _FaceRecognizeState extends State<FaceRecognize> {

  final ImagePicker _picker = ImagePicker();
  File? _image;
  void pickImageFromGallery() async {
    var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage!.path);
    });
    doFaceDetection();
  }

  void pickImageFromCamera() async {
    var pickedImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedImage!.path);
    });
    doFaceDetection();
  }

  late FaceDetector faceDetector;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final options = FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: options);
  }

  doFaceDetection() async {

    InputImage inputImage = InputImage.fromFile(_image!);

    print(inputImage.filePath);

    final List<Face> faces = await faceDetector.processImage(inputImage);

    print("$faces");

    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      print("Rect = $boundingBox");
    }

    print("$faces");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detection'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(),
            if(_image != null)
            Container(
              child: Image.file(File(_image!.path)),
            ),
            KButton(
              title: 'Upload Image',
              onClick: (){
                showModalBottomSheet(
                  context: context,
                  builder: (context){
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
          ],
        ),
      ),
    );
  }
}
