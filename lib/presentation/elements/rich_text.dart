import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String firstText;
  final String tappableText;
  final VoidCallback onTap;
  const CustomRichText(
      {required this.firstText,
      required this.tappableText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: firstText,
          style: TextStyle(
              fontFamily: "Tajawal",
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
                text: tappableText,
                style: TextStyle(
                    fontFamily: "Tajawal",
                    color: FrontEndConfigs.buttonColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()..onTap = () => onTap())
          ]),
    );
  }
}
