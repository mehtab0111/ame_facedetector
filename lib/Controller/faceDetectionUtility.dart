import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// Method to get the device's current rotation relative to its "native" orientation
Future<int> getRotationCompensation(CameraDescription camera, {required bool isFrontFacing}) async {
  final int rotation;

  // For Android, get rotation from native code
  if (Platform.isAndroid) {
    rotation = await _getAndroidRotation();
  } else {
    // For iOS, assuming the default device orientation is Portrait
    rotation = 0;
  }

  // Get sensor orientation from the CameraDescription
  final int sensorOrientation = camera.sensorOrientation;

  int rotationCompensation;
  if (isFrontFacing) {
    rotationCompensation = (sensorOrientation + rotation) % 360;
  } else { // back-facing
    rotationCompensation = (sensorOrientation - rotation + 360) % 360;
  }

  return rotationCompensation;
}

// Platform-specific code to get the Android rotation
Future<int> _getAndroidRotation() async {
  const platform = MethodChannel('com.example.rotation/rotation');
  try {
    final int rotation = await platform.invokeMethod('getRotation');
    return rotation;
  } on PlatformException catch (e) {
    print("Failed to get rotation: '${e.message}'.");
    return 0; // Default to 0 if unable to get rotation
  }
}
