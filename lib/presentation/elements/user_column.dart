import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UserColumn extends StatelessWidget {
  final String image;
  final String label;
  final double height;
  final double width;
  final VoidCallback onTap;
  UserColumn(
      {required this.image,
      required this.label,
      required this.onTap,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        children: [



          Image.asset(
            image,
            height: height,
            width: width,
          ),
          Booster.verticalSpace(20),
          Booster.dynamicFontSize(
              label: label.tr(),
              fontFamily:
                  context.locale == Locale('en') ? "Poppins" : "Tajawal",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white)
        ],
      ),
    );
  }
}
