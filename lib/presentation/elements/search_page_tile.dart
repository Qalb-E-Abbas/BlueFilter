import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:booster/booster.dart';
import 'package:flutter/material.dart';

class SearchPageArTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Booster.paddedWidget(
        left: 20,
        right: 20,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info,
                      size: 34,
                      color: FrontEndConfigs.bgColor,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Booster.dynamicFontSize(
                            label: "أحمد خليل عثمان",
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        Booster.verticalSpace(8),
                        Booster.dynamicFontSize(
                            label: "موسرجي / كهربائي",
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: FrontEndConfigs.darkTextColor),
                        Booster.verticalSpace(5),
                        Booster.dynamicFontSize(
                            label: "شارع الإرسال، رام الله",
                            fontSize: 15,
                            color: FrontEndConfigs.darkTextColor,
                            fontWeight: FontWeight.w400),
                      ],
                    ),
                    Booster.horizontalSpace(20),
                    Booster.localProfileAvatar(
                        radius: 60, assetImage: "assets/images/dp.png")
                  ],
                ),
              ],
            ),
            Booster.verticalSpace(10),
            Divider(
              color: FrontEndConfigs.dividerColor,
              thickness: 2,
            ),
            Booster.verticalSpace(20),
          ],
        ));
  }
}
