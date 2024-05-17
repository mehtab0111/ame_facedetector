import 'dart:io';
import 'dart:typed_data';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Rekognition? _rekognition;

void initRekognition() {
  final credentials = AwsClientCredentials(
    accessKey: 'AKIA5FTZBLYNSHY4Q54R',
    secretKey: '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',
  );

  _rekognition = Rekognition(region: 'us-east-1', credentials: credentials);
}

Future<void> listFaceCollections() async {
  try {
    // Initialize AWS Rekognition client
    final rekognition = Rekognition(region: 'us-east-1');

    // List face collections
    final response = await rekognition.listCollections();

    // Process the response
    for (var collectionId in response.collectionIds!) {
      print('Face collection ID: $collectionId');
    }

    print('Hello test data');
  } catch (e) {
    print('Error listing face collections: $e');
  }
}

Future<void> detectFaces(String imagePath) async {
  try {
    print('Started detecting faces...');
    final imageBytes = await File(imagePath).readAsBytes();
    final result = await _rekognition!.detectFaces(
      image: Image(bytes: Uint8List.fromList(imageBytes)),
    );

    for (var faceDetail in result.faceDetails!) {
      print('Detected face with confidence: ${faceDetail.confidence}');
      print('Age range: ${faceDetail.ageRange}');
      print('Gender: ${faceDetail.gender}');
      // print('Label (ExternalImageId): ${faceDetail.externalImageId}');

    }

    print('Started detecting success...');
    print(result.faceDetails);
  } catch (e) {
    print('Error detecting faces: $e');
  }
}

Future<List<String>> detectLabels(String imagePath) async {
  try {
    print('Detecting labels...');
    final imageBytes = await File(imagePath).readAsBytes();
    final response = await _rekognition!.detectLabels(
      image: Image(bytes: Uint8List.fromList(imageBytes)),
    );

    List<String> labels = [];
    for (var label in response.labels!) {
      labels.add(label.name!);
    }
    print('label: $labels');
    return labels;
  } catch (e) {
    print('Error detecting labels: $e');
    return [];
  }
}

// Future<List<String>> compareFaces(String sourceImagePath, String targetImagePath) async {
//   try {
//     print('Comparing faces...');
//     final sourceImageBytes = await File(sourceImagePath).readAsBytes();
//     final targetImageBytes = await File(targetImagePath).readAsBytes();
//
//     final sourceImage = Image(bytes: Uint8List.fromList(sourceImageBytes));
//     final targetImage = Image(bytes: Uint8List.fromList(targetImageBytes));
//
//     final response = await _rekognition!.compareFaces(
//       sourceImage: sourceImage,
//       targetImage: targetImage,
//     );
//
//     List<String> labels = [];
//     for (var faceMatch in response.faceMatches!) {
//       labels.add('Face at ${faceMatch}');
//       labels.add('Similarity: ${faceMatch.similarity}');
//     }
//     print('Label: ${labels}');
//     return labels;
//   } catch (e) {
//     print('Error comparing faces: $e');
//     return [];
//   }
// }

Future<double> compareFaces(String networkImageUrl, String pickedImagePath) async {
  try {
    print('Comparing faces...');

    // Download the network image to a temporary file
    var res = await http.get(Uri.parse(networkImageUrl));
    var tempDir = await Directory.systemTemp.createTemp('temp_image');
    var tempImagePath = '${tempDir.path}/temp_image.jpg';
    var file = File(tempImagePath);
    await file.writeAsBytes(res.bodyBytes);

    final pickedImageBytes = await File(pickedImagePath).readAsBytes();
    final tempImageBytes = await File(tempImagePath).readAsBytes();

    final pickedImage = Image(bytes: Uint8List.fromList(pickedImageBytes));
    final tempImage = Image(bytes: Uint8List.fromList(tempImageBytes));

    final response = await _rekognition!.compareFaces(
      sourceImage: pickedImage,
      targetImage: tempImage,
    );

    List<String> labels = [];
    for (var faceMatch in response.faceMatches!) {
      // labels.add('Face at ${faceMatch.boundingBox}');
      labels.add('Similarity: ${faceMatch.similarity}');
    }

    // Delete the temporary file
    await file.delete();

    double similarity = double.parse(labels[0].substring(labels[0].indexOf(':') + 2, labels[0].length - 1));
    print('Similarity: $similarity');

    print('Label: ${labels}');
    // return labels;
    return similarity;
  } catch (e) {
    print('Error comparing faces: $e');
    return 0.0;
  }
}
