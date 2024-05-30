import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceManager {

  static String companyNumber = '';
  static String companyAddress = '';
  static String supportEmail = '';

  static String userID = '';
  static String profileURL = '';
  static String userName = '';
  static String userEmail = '';
  static String userMobile = '';

  static String deliveryName = '';
  static String deliveryAddress = '';
  static String aboutUS = '';
  static int cartNumber = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setUser (String userID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', userID);
  }

  void getUserID () async {
    final prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') ?? '';
    if(userID != ''){
      getUserData();
    }
  }

  void removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userID');
    userID = '';
  }

  void getUserData() async {

  }

  // void updateAll() async {
  //   QuerySnapshot snapshot = await  _firestore.collection('employee').get();
  //   for (QueryDocumentSnapshot document in snapshot.docs) {
  //     try {
  //       await _firestore.collection('employee').doc(document.id).update({
  //         '': '',
  //       });
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  //   print('All documents updated successfully');
  // }

  Future<String> uploadImage(String imagePath, String folderName) async {
    try{
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference storageRef = storage.ref().child(folderName);
      final String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference imageRef = storageRef.child(imageName);
      final UploadTask uploadTask = imageRef.putFile(File(imagePath));
      final TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await storageSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e){
      print('Error uploading image: $e');
    }
    return '';
  }
}