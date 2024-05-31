import 'dart:io';
import 'package:ame_facedetector/Controller/location.dart';
import 'package:ame_facedetector/View/Components/buttons.dart';
import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:ame_facedetector/View/Components/util.dart';
import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:ame_facedetector/awsconfig.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FaceDetectionScreen extends StatefulWidget {
  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CameraController? _controller;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  XFile? _capturedFile;
  late List<CameraDescription> _cameras;
  bool _isFrontCamera = false;
  bool _isCameraInitialized = false;

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  File? _image;

  double matchPercentage = 0.0;
  Future<void> _pickImage() async {
    setState(() {
      isLoading = true;
    });
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // matchPercentage = await compareFaces(employeeImage, pickedFile.path);
      // setState(() {
      //   _image = File(pickedFile.path);
      // });
      // isLoading = false;
      //
      // ///label
      // labels = await detectCustomLabels(_image!.path);
      // // labels = await detectPersons(_image!.path);
      // print(labels);
      // setState(() {});

      ///new
      compareImages(pickedFile).whenComplete((){
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Map<String, dynamic> matchedData = {};
  Future<void> compareImages(pickedFile) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('employee').get();
      List<String> imageUrls = [];
      double matchPercentage = 0.0;
      String matchedImageUrl = '';
      bool isMatchFound = false;

      // Collect all image URLs from the documents
      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data.containsKey('image') && data['image'] is String) {
          imageUrls.add(data['image']);
        }
      }

      // Compare faces and find the match
      for (var image in imageUrls) {
        matchPercentage = await compareFaces(image, pickedFile.path);
        if (matchPercentage > 90) {
          matchedImageUrl = image;
          // Find the matching document data
          for (QueryDocumentSnapshot document in snapshot.docs) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            if (data['image'] == matchedImageUrl) {
              matchedData = data;
              giveAttendance(document.reference.id);
              isMatchFound = true; // Mark match as found
              break; // Exit the inner loop once the match is found
            }
          }
          if (isMatchFound) {
            break; // Exit the outer loop once the match is found
          }
        }
      }

      if (matchedData != null) {
        // Store the matched document data or perform any further actions
        print('Matched image URL: $matchedImageUrl with percentage: $matchPercentage');
        print('Matched document data: $matchedData');
        // You can store this data in Firestore or any other storage
      }

      // If no match was found, show a message
      if (!isMatchFound) {
        // Replace this with your method to show a message, e.g., using a dialog or a snackbar
        toastMessage(message: 'No matching image found, scan again');
      }

    } catch (e) {
      print('Error fetching images: $e');
    }
  }



  List<String> labels = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableLandmarks: true,
        enableContours: true,
      ),
    );
  }

  Future<void> _initializeCamera([CameraDescription? cameraDescription]) async {
    try {
      _cameras = await availableCameras();
      final camera = cameraDescription ?? _cameras.first;

      _controller = CameraController(camera, ResolutionPreset.ultraHigh, enableAudio: false);
      await _controller?.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
      _startFaceDetection();
    } catch (e) {
      print('Error initializing camera: $e');
      setState(() {
        _isCameraInitialized = false;
      });
    }
  }

  void _flipCamera() async {
    if (_cameras.length > 1) {
      _isFrontCamera = !_isFrontCamera;
      final camera = _isFrontCamera ? _cameras.last : _cameras.first;
      await _controller?.dispose();
      setState(() {
        _isCameraInitialized = false;
      });
      _initializeCamera(camera);
    }
  }

  void _startFaceDetection() {
    _controller?.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;

      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
      final InputImageRotation imageRotation = _rotationIntToImageRotation(_controller!.description.sensorOrientation);
      final InputImageFormat inputImageFormat = _imageFormatFromRawValue(image.format.raw);

      final inputImageMetadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);

      _faceDetector.processImage(inputImage).then((faces) async {
        if (faces.isNotEmpty) {
          // Stop the camera
          await _controller?.stopImageStream();
          _captureImage();
        }
        _isDetecting = false;
      }).catchError((e) {
        _isDetecting = false;
        print('Error processing image: $e');
      });
    });
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  InputImageFormat _imageFormatFromRawValue(int rawValue) {
    switch (rawValue) {
      case 17: // ImageFormat.NV21
        return InputImageFormat.nv21;
      case 35: // ImageFormat.YUV_420_888
        return InputImageFormat.yuv420;
      default:
        return InputImageFormat.bgra8888; // default format
    }
  }

  Future<void> _captureImage() async {
    print('Start Capturing');
    try {
      final XFile file = await _controller!.takePicture();
      setState(() {
        _capturedFile = file;
      });
      // Handle the captured image, e.g., save it or display it
      print('Captured image: ${file.path}');

      setState(() {
        isLoading = true;
      });
      compareImages(_capturedFile).whenComplete((){
        setState(() {
          isLoading = false;
        });
        toastMessage(message: 'Scan a proper image');
      });

    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: !_isCameraInitialized ? Center(child: CircularProgressIndicator()) : Stack(
    //     children: [
    //       CameraPreview(_controller!),
    //       if (_capturedFile != null)
    //         Positioned(
    //           bottom: 20,
    //           right: 20,
    //           child: Image.file(File(_capturedFile!.path), width: 100, height: 100),
    //         ),
    //       Positioned(
    //         top: 50,
    //         right: 20,
    //         child: FloatingActionButton(
    //           onPressed: _flipCamera,
    //           child: Icon(Icons.flip_camera_ios),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
          // TextButton(
          //   onPressed: () {
          //     startProjectVersion();
          //   },
          //   child: Text('Start Model'),
          // ),
        ],
      ),
      body: !_isCameraInitialized ? Center(child: CircularProgressIndicator()) : _capturedFile != null ? SingleChildScrollView(
      // body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: roundedShadedDesign(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location', style: k14BoldStyle()),
                    Text(LocationService.userLocation),
                    kRowText('Latitude: ', '${LocationService.userLatitude}'),
                    kRowText('Longitude: ', '${LocationService.userLongitude}'),
                    Text('Time: ${DateFormat('dd-MM-yyyy - hh:mm a').format(DateTime.parse('${DateTime.now()}'))}'),
                  ],
                ),
              ),
            ),

            if(matchedData['name'] != null)
            Text('${matchedData['name']}'),
            if(matchedData['image'] != null)
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(matchedData['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            kSpace(),

            if(isLoading != false)
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              padding: EdgeInsets.all(10),
              decoration: roundedShadedDesign(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Detecting face'),
                  SizedBox(width: 10),
                  CircularProgressIndicator(),
                ],
              ),
            ),
            if(matchedData == {})
            Text('Scan a proper Image'),

            if(_image != null)
            Image.file(File(_image!.path), height: 200,),

            // if(employeeName != '')
            // matchPercentage > 90 ?
            // Column(
            //   children: [
            //     Text('Match Result: $matchPercentage'),
            //     Text('You are logged in'),
            //   ],
            // ) : Text("Scan a proper image"),
            kSpace(),
            // if(employeeName != '')
            KButton(
              onClick: _pickImage,
              title: 'Scan Image',
            ),

            // KButton(
            //   onClick: giveAttendance,
            //   title: 'Save Attendance',
            // ),
            kBottomSpace(),
          ],
        ),
      // ),
      ) : Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            top: 50,
            right: 20,
            child: FloatingActionButton(
              onPressed: _flipCamera,
              child: Icon(Icons.flip_camera_ios),
            ),
          ),
        ],
      ),
    );
  }

  // String userID = '';
  void giveAttendance(String userID) async {
    try{
      _firestore.collection('attendance').add({
        'location': LocationService.userLocation,
        'latLng': GeoPoint(LocationService.userLatitude, LocationService.userLongitude),
        'clockIn': DateTime.now(),
        'userID': userID,
      });
      toastMessage(message: 'Attendance Saved');
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }
}

///label data
// StreamBuilder(
//   stream: _firestore.collection('employee').snapshots(),
//   builder: (context, snapshot) {
//     if(snapshot.hasData){
//       var data = snapshot.data!.docs;
//       return labels.isNotEmpty ? ListView.builder(
//         shrinkWrap: true,
//         padding: EdgeInsets.symmetric(horizontal: 10),
//         physics: NeverScrollableScrollPhysics(),
//         // itemCount: labels.length > 1 ? 1 : labels.length,
//         itemCount: labels.length,
//         itemBuilder: (context, index){
//
//           RegExp regExp = RegExp(r'Label: ([^,]+), Confidence: ([\d.]+)');
//
//           // Finding all matches in the data string
//           Iterable<RegExpMatch> matches = regExp.allMatches(labels[index]);
//
//           // Extracting the label and confidence values
//           List<Map<String, dynamic>> extractedData = matches.map((match) {
//             return {
//               'Label': match.group(1),
//               'Confidence': double.parse(match.group(2)!)
//             };
//           }).toList();
//
//           // Printing the extracted data
//           extractedData.forEach((item) {
//             print('Label: ${item['Label']}, Confidence: ${item['Confidence']}');
//           });
//
//           return ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: extractedData.length,
//               itemBuilder: (context, ind) {
//                 return GestureDetector(
//                   onTap: (){
//                     print(extractedData[ind]['Label']);
//
//                     // userID = data.firstWhere((user) => user['name'] == extractedData[ind]['Label']).reference.id;
//                   },
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Name: ${extractedData[ind]['Label']}'),
//                       Text('Confidence: ${extractedData[ind]['Confidence']}'),
//                     ],
//                   ),
//                 );
//               }
//           );
//         },
//       ) : Text('Not a Proper Image Scan Again');
//     }
//     return SizedBox.shrink();
//   }
// ),
