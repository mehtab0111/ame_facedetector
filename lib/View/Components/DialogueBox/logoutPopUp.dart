import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:flutter/material.dart';

Future<String?> logoutBuilder(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text('Logout', style: kHeaderStyle()),
      content: Text('Are you sure you want to logout?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            // _auth.signOut();
            // ServiceManager().removeUser();
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            //     builder: (context) => Login()), (route) => false);
            // try {
            //   _googleSignIn.disconnect();
            // } catch (e) {
            //   print("Error signing out: $e");
            // }
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
