import 'package:blue_filter/application/user_type.dart';
import 'package:blue_filter/application/user_type_state.dart';
import 'package:blue_filter/presentation/elements/user_column.dart';
import 'package:blue_filter/presentation/views/login_view.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectTypeView extends StatefulWidget {
  @override
  _SelectTypeViewState createState() => _SelectTypeViewState();
}

class _SelectTypeViewState extends State<SelectTypeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getUI(context),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Booster.verticalSpace(100),
          Booster.dynamicFontSize(
              label: "BLUE FILTER",
              fontSize: 39,
              color: Colors.white,
              fontWeight: FontWeight.w600),
          Booster.verticalSpace(10),
          Booster.dynamicFontSize(
              label: "معاً لمياه نظيفة",
              fontSize: 29,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: "Tajawal"),
          Booster.verticalSpace(80),
          Booster.dynamicFontSize(
              label: "loginas".tr(), fontSize: 20, color: Colors.white),
          Booster.verticalSpace(50),
          _getUserRow(context),
          Booster.verticalSpace(80),
          _getLanguageRow(context)
        ],
      ),
    );
  }

  Widget _getUserRow(BuildContext context) {
    var userType = Provider.of<UserTypeProvider>(context);
    var user = Provider.of<UserType>(context);
    print(userType.getUserType);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: UserColumn(
              onTap: () {
                user.saveUserType("client");
                userType.saveUserType("client");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginView()));
              },
              image: "assets/images/user.png",
              label: "user".tr(),
              height: 110,
              width: 83),
        ),
        Booster.horizontalSpace(30),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: UserColumn(
              onTap: () {
                user.saveUserType("service_provider");
                userType.saveUserType("service_provider");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginView()));
              },
              image: "assets/images/user-cog.png",
              label: "serviceprovider".tr(),
              width: 110,
              height: 90),
        ),
      ],
    );
  }

  Widget _getLanguageRow(BuildContext context) {
    return Container(
      height: 37,
      width: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), color: Color(0xff3D80E3)),
      child: Booster.paddedWidget(
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Booster.dynamicFontSize(
                    label: "English", fontSize: 13, color: Colors.white),
                onTap: () {
                  setState(() {});
                  context.locale = Locale("en");
                },
              ),
              Booster.paddedWidget(
                  left: 6,
                  right: 6,
                  child: Container(
                    height: 37,
                    width: 4,
                    color: Color(0xff679EF4),
                  )),
              InkWell(
                onTap: () {
                  setState(() {});
                  context.locale = Locale("ar");
                },
                child: Booster.dynamicFontSize(
                    fontFamily: "Tajawal",
                    label: "العربية",
                    fontSize: 13,
                    color: Colors.white),
              )
            ],
          )),
    );
  }
}
