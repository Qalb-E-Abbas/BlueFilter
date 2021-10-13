import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/models/postModel.dart';
import 'package:blue_filter/presentation/elements/appDrawer.dart';
import 'package:blue_filter/presentation/elements/custom_appBar.dart';
import 'package:booster/booster.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SingleBlogView extends StatelessWidget {
  Datum model;
  SingleBlogView(this.model);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getUI(context),
      drawer: AppDrawer(),
    );
  }

  Widget _getUI(BuildContext context) {
    return Container(
      height: Booster.screenHeight(context),
      width: Booster.screenWidth(context),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/splashBG.png'))),
      child: Column(
        children: [
          Booster.verticalSpace(70),
          CustomAppBar(title: "blog".tr()),
          Booster.verticalSpace(30),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Booster.verticalSpace(20),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Booster.horizontalSpace(20),
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Booster.horizontalSpace(10),
                      Booster.dynamicFontSize(
                          label: model.title ?? "",
                          fontFamily: context.locale == Locale('en')
                              ? "Poppins"
                              : "Tajawal",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      Booster.horizontalSpace(10),
                    ],
                  ),
                ),
                Booster.verticalSpace(20),
                CachedNetworkImage(
                  imageUrl: model.featuredImage!,
                  placeholder: (context, url) => Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Booster.verticalSpace(25),
                Booster.paddedWidget(
                    left: 20,
                    right: 20,
                    child: Booster.dynamicFontSize(
                        label: model.body ?? "",
                        fontSize: 16,
                        fontFamily: context.locale == Locale('en')
                            ? "Poppins"
                            : "Tajawal",
                        fontWeight: FontWeight.w500,
                        color: FrontEndConfigs.darkTextColor,
                        // textDirection: TextDirection.rtl,
                        isAlignCenter: false))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
