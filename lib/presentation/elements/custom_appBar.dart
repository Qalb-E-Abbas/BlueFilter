import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Booster.paddedWidget(
      right: 20,
      left: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Booster.dynamicFontSize(
              label: title.tr(), fontSize: 20, color: Colors.white),
          Builder(
            builder: (context) {
              return InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Image.asset(
                  'assets/images/menu.png',
                  height: 25,
                  width: 25,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
