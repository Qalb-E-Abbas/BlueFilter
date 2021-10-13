import 'dart:async';

import 'package:blue_filter/presentation/views/wrapper.dart';
import 'package:booster/booster.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  final String userType;
  SplashView(this.userType);
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(
        Duration(
          seconds: 3,
        ), () {
      print("Timer : ${widget.userType}");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Wrapper()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Booster.screenHeight(context),
        width: Booster.screenWidth(context),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/splashBG.png'))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Booster.verticalSpace(280),
            Booster.dynamicFontSize(
                label: "BLUE FILTER",
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            Booster.verticalSpace(20),
            Booster.dynamicFontSize(
                fontFamily: "Tajawal",
                label: "معاً لمياه نظيفة",
                fontSize: 36,
                color: Colors.white),
            Booster.verticalSpace(180),
            Booster.dynamicFontSize(
                label: "www.bluefilter.ps", fontSize: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
