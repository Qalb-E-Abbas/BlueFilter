import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:booster/booster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelIconRow extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  LabelIconRow(
      {required this.text,
      required this.icon,
      required this.controller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 7),
          width: 20,
          height: 20,
          child: Center(
            child: Icon(
              icon,
              color: FrontEndConfigs.bgColor,
            ),
          ),
        ),
        Booster.horizontalSpace(15),
        Expanded(
            child: TextFormField(
              controller: controller,
              validator: validator,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              decoration: InputDecoration(
                  hintText: text,
                  border: UnderlineInputBorder(borderSide: BorderSide.none)),
            )),
        // Booster.dynamicFontSize(
        //     label: text, fontSize: 20, fontWeight: FontWeight.w500),
      ],
    );
  }
}
