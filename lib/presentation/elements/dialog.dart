import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showErrorDialog(
  BuildContext context, {
  required String message,
}) async {
  showDialog(
      barrierDismissible: false,
      context: (context),
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Message_Error_Title".tr(),
            style: TextStyle(color: Colors.red),
          ),
          content: Text(message),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Message_Error_Button".tr()))
          ],
        );
      });
}
