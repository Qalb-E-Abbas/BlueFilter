import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showNavigationDialog(BuildContext context,
    {required String message,
    required String buttonText,
    required VoidCallback navigation,
    required String secondButtonText,
    required bool showSecondButton}) async {
  showDialog(
      barrierDismissible: false,
      context: (context),
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Message_Success_Title".tr(),
            style: TextStyle(color: Colors.green[900]),
          ),
          content: Text(message),
          actions: [
            if (showSecondButton == true)
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(secondButtonText)),
            FlatButton(onPressed: () => navigation(), child: Text(buttonText)),
          ],
        );
      });
}
