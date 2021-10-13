import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:flutter/material.dart';

class DialogBoxContainer extends StatelessWidget {
  final IconData icon;
  DialogBoxContainer({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: FrontEndConfigs.bgColor),
      ),
      child: Center(
        child: Icon(
          icon,
          color: FrontEndConfigs.bgColor,
        ),
      ),
    );
  }
}
