import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchFilterBox extends StatelessWidget {
  final String text;
  final Color color1;
  final Color color2;
  final Color textColor;
  final bool isSelected;
  SearchFilterBox(
      {required this.text,
      required this.color1,
      required this.color2,
      required this.isSelected,
      required this.textColor});
  @override
  Widget build(BuildContext context) {
    return Booster.paddedWidget(
      left: 5,
      right: 5,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: !isSelected
                    ? [color1, color2]
                    : [Colors.blue, Colors.blue])),
        child: Booster.paddedWidget(
            left: 20,
            right: 20,
            child: Center(
              child: Booster.dynamicFontSize(
                  label: text.tr(),
                  fontSize: 14,
                  color: isSelected ? Colors.white : textColor),
            )),
      ),
    );
  }
}
