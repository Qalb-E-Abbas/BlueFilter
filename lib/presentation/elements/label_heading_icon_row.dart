import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:booster/booster.dart';
import 'package:flutter/material.dart';

class LabelHeadingIconRow extends StatelessWidget {
  final String label;
  final String heading;
  final IconData icon;
  final VoidCallback? onTap;

  LabelHeadingIconRow(
      {required this.label,
      required this.heading,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Booster.paddedWidget(
          bottom: 10,
          top: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Icon(
                icon,
                color: FrontEndConfigs.bgColor,
              ),
              Booster.horizontalSpace(15),

              Booster.dynamicFontSize(
                  label: label,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: FrontEndConfigs.darkTextColor),
              Booster.horizontalSpace(15),

              Booster.dynamicFontSize(
                  label: heading, fontSize: 20, fontWeight: FontWeight.w500),
            ],
          ),
        ),);
  }
}
