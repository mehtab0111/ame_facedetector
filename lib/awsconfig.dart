import 'dart:io';
import 'dart:typed_data';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:http/http.dart' as http;

// MODEL_ARN=arn:aws:rekognition:us-east-1:your_account_id:AME_faceDetection.2024-05-16T16.40.47

const String projectVersionArn = 'arn:aws:rekognition:us-east-1:905418202651:project/AME_faceDetection/version/AME_faceDetection.2024-05-16T16.40.47/1715857848924';

Rekognition? _rekognition;

void initRekognition() {
  final credentials = AwsClientCredentials(
    accessKey: 'AKIA5FTZBLYNSHY4Q54R',
    secretKey: '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',
  );

  _rekognition = Rekognition(region: 'us-east-1', credentials: credentials);
}

Future<void> startProjectVersion() async {
  try {
    await _rekognition!.startProjectVersion(
      projectVersionArn: projectVersionArn,
      minInferenceUnits: 1,
    );

    // Wait until the model is running
    bool isRunning = false;
    while (!isRunning) {
      final response = await _rekognition!.describeProjectVersions(
        projectArn: projectVersionArn.split('/version/')[0],
      );

      final projectVersion = response.projectVersionDescriptions!.firstWhere(
            (version) => version.projectVersionArn == projectVersionArn,
      );

      if (projectVersion.status == 'RUNNING') {
        isRunning = true;
      } else {
        await Future.delayed(Duration(seconds: 10)); // Wait before checking again
      }
    }
  } catch (e) {
    print('Error starting project version: $e');
  }
}


Future<void> stopProjectVersion() async {
  try {
    await _rekognition!.stopProjectVersion(
      projectVersionArn: projectVersionArn,
    );
    print('Project version stopped successfully.');
  } catch (e) {
    print('Error stopping project version: $e');
  }
}

Future<List<String>> detectCustomLabels(String imagePath) async {
  try {
    // await startProjectVersion();

    final imageBytes = await File(imagePath).readAsBytes();
    final image = Image(bytes: Uint8List.fromList(imageBytes));

    final response = await _rekognition!.detectCustomLabels(
      projectVersionArn: projectVersionArn,
      image: image,
      minConfidence: 45,
    );

    List<String> labels = [];
    for (var customLabel in response.customLabels!) {
      labels.add('Label: ${customLabel.name}, Confidence: ${customLabel.confidence}');
    }

    return labels;
  } catch (e) {
    print('Error detecting custom labels: $e');
    return [];
  }
}

///detect faces
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
