import 'package:ame_facedetector/Controller/faceDetectionUtility.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({required this.camera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late FaceDetector _faceDetector;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
    _faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableLandmarks: true,
      enableClassification: true,
    ));

    _controller.startImageStream((CameraImage image) {
      if (_isProcessing) return;
      _isProcessing = true;

      processImage(image).then((_) => _isProcessing = false);
    });
  }

  Future<void> processImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final InputImageRotation imageRotation = _rotationIntToImageRotation(
        _controller!.description.sensorOrientation);
    final InputImageFormat inputImageFormat = _imageFormatFromRawValue(image.format.raw);

    // final int imageRotation = await getRotationCompensation(widget.camera, isFrontFacing: widget.camera.lensDirection == CameraLensDirection.front);

    final inputImageMetadata = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      // inputImageRotation: imageRotation,
      metadata: inputImageMetadata,
    );

    final faces = await _faceDetector.processImage(inputImage);

    for (Face face in faces) {
      // Process each detected face
      print('Detected face: ${face.boundingBox}');
    }
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

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}