import 'dart:io';
import 'package:ame_facedetector/Controller/location.dart';
import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Components/kDatabase.dart';
import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:ame_facedetector/awsconfig.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FaceDetectionScreen extends StatefulWidget {
  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {

  // CameraController? _controller;
  // late FaceDetector _faceDetector;
  // bool _isDetecting = false;

  // Users? selectedUser;
  String employeeValue = '';
  String employeeImage = '';
  String employeeName = '';
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  File? _image;

  double matchPercentage = 0.0;
  Future<void> _pickImage() async {
    setState(() {
      isLoading = true;
    });
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // await detectFaces(pickedFile.path);
      // await detectLabels(pickedFile.path);
      // compareFaces(pickedFile.path, pickedFile.path);

      matchPercentage = await compareFaces(employeeImage, pickedFile.path);
      setState(() {
        _image = File(pickedFile.path);
      });
      isLoading = false;

      ///label
      labels = await detectCustomLabels(_image!.path);
      print(labels);
      setState(() {});
    }
  }

  List<String> labels = [];


  // @override
  // void initState() {
  //   super.initState();
  //   _initializeCamera();
  //   _faceDetector = FaceDetector(
  //     options: FaceDetectorOptions(
  //       enableLandmarks: true,
  //       enableContours: true,
  //     ),
  //   );
  // }
  //
  // Future<void> _initializeCamera() async {
  //   final cameras = await availableCameras();
  //   final camera = cameras.first;
  //
  //   _controller = CameraController(camera, ResolutionPreset.medium);
  //   await _controller?.initialize();
  //   _startFaceDetection();
  //   setState(() {});
  // }
  //
  // void _startFaceDetection() {
  //   _controller?.startImageStream((CameraImage image) {
  //     if (_isDetecting) return;
  //     _isDetecting = true;
  //
  //     final WriteBuffer allBytes = WriteBuffer();
  //     for (Plane plane in image.planes) {
  //       allBytes.putUint8List(plane.bytes);
  //     }
  //     final bytes = allBytes.done().buffer.asUint8List();
  //
  //     final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
  //
  //     final InputImageRotation imageRotation = _rotationIntToImageRotation(
  //         _controller!.description.sensorOrientation);
  //
  //     final InputImageFormat inputImageFormat = _imageFormatFromRawValue(image.format.raw);
  //
  //     final planeData = image.planes.map(
  //           (Plane plane) {
  //         return InputImagePlaneMetadata(
  //           bytesPerRow: plane.bytesPerRow,
  //           height: plane.height,
  //           width: plane.width,
  //         );
  //       },
  //     ).toList();
  //
  //     final inputImageData = InputImageData(
  //       size: imageSize,
  //       imageRotation: imageRotation,
  //       inputImageFormat: inputImageFormat,
  //       planeData: planeData,
  //     );
  //
  //     final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  //
  //     _faceDetector.processImage(inputImage).then((faces) async {
  //       if (faces.isNotEmpty) {
  //         // Stop the camera
  //         await _controller?.stopImageStream();
  //         _captureImage();
  //       }
  //       _isDetecting = false;
  //     });
  //   });
  // }
  //
  // InputImageRotation _rotationIntToImageRotation(int rotation) {
  //   switch (rotation) {
  //     case 90:
  //       return InputImageRotation.rotation90deg;
  //     case 180:
  //       return InputImageRotation.rotation180deg;
  //     case 270:
  //       return InputImageRotation.rotation270deg;
  //     default:
  //       return InputImageRotation.rotation0deg;
  //   }
  // }
  //
  // InputImageFormat _imageFormatFromRawValue(int rawValue) {
  //   switch (rawValue) {
  //     case 17: // ImageFormat.NV21
  //       return InputImageFormat.nv21;
  //     case 35: // ImageFormat.YUV_420_888
  //       return InputImageFormat.yuv420;
  //     default:
  //       return InputImageFormat.bgra8888; // default format
  //   }
  // }

  // Future<void> _captureImage() async {
  //   final XFile file = await _controller!.takePicture();
  //   // Handle the captured image, e.g., save it or display it
  //   print('Captured image: ${file.path}');
  // }
  //
  // @override
  // void dispose() {
  //   _controller?.dispose();
  //   _faceDetector.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text('Employee Attendance'),
        actions: [
          // TextButton(
          //   onPressed: () async {
          //     stopProjectVersion();
          //   },
          //   child: Text('Stop Model'),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location', style: k14BoldStyle()),
                  Text(LocationService.userLocation),
                  Text('Latitude: ${LocationService.userLatitude}'),
                  Text('Longitude: ${LocationService.userLongitude}'),
                  Text('Time: ${DateFormat('dd-MM-yyyy - hh:mm a').format(DateTime.parse('${DateTime.now()}'))}'),
                  kSpace(),
                  // Text('Select Employee', style: k14BoldStyle()),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: dropTextFieldDesign(context),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10.0),
                      value: employeeValue != '' ? employeeValue : null,
                      hint: Text('Select State', style: hintTextStyle(context)),
                      items: userList
                          .map<DropdownMenuItem>((value) {
                        return DropdownMenuItem(
                          value: value.userID,
                          child: Text(value.userName),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          employeeValue = newValue;
                          employeeImage = userList.firstWhere((user) => user.userID == newValue).image;
                          employeeName = userList.firstWhere((user) => user.userID == newValue).userName;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (employeeName != '')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.network(
                      employeeImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10),
                    Text(employeeName),
                  ],
                ),
              ),
            kSpace(),
            if(_image != null)
            Image.file(File(_image!.path), height: 200,),

            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              physics: NeverScrollableScrollPhysics(),
              itemCount: labels.length,
              itemBuilder: (context, index){
                return Text(labels[index]);
              },
            ),
            if(employeeName != '')
            matchPercentage > 90 ?
            Column(
              children: [
                Text('Match Result: $matchPercentage'),
                Text('You are logged in'),
              ],
            ) : Text("Scan a proper image"),
            kSpace(),
            if(employeeName != '')
            KButton(
              onClick: _pickImage,
              title: 'Scan Image',
            ),
          ],
        ),
      ),
    );
  }
}
