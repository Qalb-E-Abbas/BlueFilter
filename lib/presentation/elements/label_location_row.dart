import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:booster/booster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelLocationRow extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  LabelLocationRow(
      {required this.text,
      required this.icon,
      required this.controller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Booster.paddedWidget(
      bottom: 6,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            child: Icon(
              icon,
              color: FrontEndConfigs.bgColor,
            ),
          ),
          Booster.horizontalSpace(15),
          Booster.dynamicFontSize(
              label: text,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: FrontEndConfigs.darkTextColor),
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
      ),
    );
  }
}
