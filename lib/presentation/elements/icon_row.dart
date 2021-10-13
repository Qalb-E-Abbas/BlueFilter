import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:booster/booster.dart';
import 'package:flutter/material.dart';

class IconRow extends StatelessWidget {
  final String title;
  final IconData icon;

  IconRow({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: FrontEndConfigs.bgColor,
        ),
        Booster.horizontalSpace(5),
        Container(
          width: 200,
          child: Booster.dynamicFontSize(
              label: title,
              isAlignCenter: false,
              fontSize: 16,
              color: FrontEndConfigs.darkTextColor,
              fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
