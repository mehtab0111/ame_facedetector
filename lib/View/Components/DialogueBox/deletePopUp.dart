import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:flutter/material.dart';

Future<String?> deletePopUp(BuildContext context, {required Function() onClickYes}) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text('Delete?', style: kHeaderStyle()),
      content: Text('You are sure you want to delete this?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onClickYes,
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
