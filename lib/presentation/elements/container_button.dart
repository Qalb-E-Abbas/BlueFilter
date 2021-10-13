import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ContainerButton extends StatelessWidget {
  final VoidCallback onTap;
  ContainerButton(this.onTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
          width: Booster.screenWidth(context),
          height: 47,
          color: FrontEndConfigs.bgColor,
          child: Center(
            child: Booster.dynamicFontSize(
                label: "update_info".tr(), fontSize: 20, color: Colors.white),
          )),
    );
  }
}
