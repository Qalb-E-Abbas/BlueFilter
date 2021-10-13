import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final String text;
  TextContainer({required this.text});

  @override
  Widget build(BuildContext context) {
    return Booster.paddedWidget(
      left: 5,
      right: 5,
      top: 4,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: FrontEndConfigs.bgColor),
            child: Center(
                child: Booster.paddedWidget(
              left: 14,
              right: 14,
              child: Booster.dynamicFontSize(
                  label: text.tr(),
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            )),
          ),
        ],
      ),
    );
  }
}
