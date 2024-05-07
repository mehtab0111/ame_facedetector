import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceManager {

  static String companyNumber = '';
  static String companyAddress = '';
  static String supportEmail = '';
  static String razorPayKey = 'rzp_live_h5nwPTx2912ZJH';
  // static String razorPayKey = 'rzp_test_fx15BZenrqFdd1'; //test

  static String userID = '';
  static String profileURL = '';
  static String userName = '';
  static String userEmail = '';
  static String userMobile = '';

  static String deliveryName = '';
  static String deliveryAddress = '';
  static String aboutUS = '';
  static int cartNumber = 0;

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}