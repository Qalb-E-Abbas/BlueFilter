import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:blue_filter/presentation/elements/appDrawer.dart';
import 'package:blue_filter/presentation/elements/custom_appBar.dart';
import 'package:blue_filter/presentation/elements/dialog_box_container.dart';
import 'package:blue_filter/presentation/elements/google_map.dart';
import 'package:blue_filter/presentation/elements/icon_row.dart';
import 'package:blue_filter/presentation/elements/text_contaier.dart';
import 'package:blue_filter/presentation/helper/url_launcher_helper.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

class MyServiceProfileView extends StatefulWidget {
  @override
  _MyServiceProfileViewState createState() => _MyServiceProfileViewState();
}

class _MyServiceProfileViewState extends State<MyServiceProfileView> {
  _showShareDialog(BuildContext context) async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
        context: context,
        barrierColor: Color(0xe683B2F5),
        builder: (BuildContext context) {
          final height = MediaQuery.of(context).size.height;
          return Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.33),
              child: Container(
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 56),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Booster.dynamicFontSize(
                                      label: "Share_This_App".tr(),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                  Booster.verticalSpace(25),
                                  Container(
                                      height: 58,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/fb.png',
                                            height: 48,
                                            width: 48,
                                          ),
                                          Image.asset(
                                            'assets/images/insta.png',
                                            height: 48,
                                            width: 48,
                                          ),
                                          Image.asset(
                                            'assets/images/email.png',
                                            height: 48,
                                            width: 48,
                                          ),
                                        ],
                                      )),
                                  Booster.verticalSpace(20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    _showShareDialog(context);
    super.initState();
  }

  final LocalStorage storage = new LocalStorage(BackendConfigs.localDB);

  bool initialized = false;

  late SuccessfulLoginModel userModel;

  var userData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!initialized) {
            var items = storage.getItem(BackendConfigs.loginUserData);

            if (items != null) {
              print(items);
              userModel = SuccessfulLoginModel(
                  data: Data(
                      token: items['data']['token'],
                      user: User(
                          id: items['data']['user']['id'],
                          email: items['data']['user']['email'],
                          name: items['data']['user']['name'],
                          type: "",
                          locale: items['data']['user']['locale'],
                          profileCompleted: "",
                          category: items['data']['user']['category'],
                          profileImage: "",
                          profileThumbnail: "",
                          phone: items['data']['user']['phone'],
                          longitude: items['data']['user']['longitude'],
                          latitude: items['data']['user']['latitude'],
                          bio: items['data']['user']['bio'],
                          notification: "",
                          facebook: items['data']['user']['facebook'],
                          service_provider_clicks: items['data']['user']
                              ['service_provider_clicks'],
                          instagram: items['data']['user']['instagram'],
                          twitter: items['data']['user']['twitter'],
                          spotify: items['data']['user']['spotify'],
                          address: items['data']['user']['address'],
                          distance: "")));
            }
            print(items);

            initialized = true;
          }
          return snapshot.data == null
              ? CircularProgressIndicator()
              : _getCreateUI(context, userModel);
        });
  }

  Widget _getCreateUI(BuildContext context, SuccessfulLoginModel model) {
    return Scaffold(
      body: _getUI(context, model),
      drawer: AppDrawer(),
    );
  }

  Widget _getUI(BuildContext context, SuccessfulLoginModel _model) {
    print(_model.data!.user.category.length);
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
          CustomAppBar(
            title: "my_account",
          ),
          Booster.verticalSpace(30),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Booster.verticalSpace(30),
                  Booster.paddedWidget(
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Booster.dynamicFontSize(
                              label: _model.data!.user.name,
                              fontSize: 26,
                            ),
                            Booster.verticalSpace(5),
                            IconRow(
                                title: _model.data!.user.address,
                                icon: Icons.location_on),
                            Booster.verticalSpace(5),
                            IconRow(
                                title: "N/A",
                                icon: Icons.remove_red_eye_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Booster.verticalSpace(20),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      ..._model.data!.user.category
                          .asMap()
                          .map((i, element) => MapEntry(
                              i,
                              _model.data!.user.locale == "ar"
                                  ? TextContainer(text: element[i]['name_ar'])
                                  : TextContainer(text: element[i]['name'])))
                          .values
                          .toList(),
                    ],
                  ),
                  Booster.verticalSpace(30),
                  Container(
                    height: 190,
                    child: GetMapView(
                      lat: double.parse(_model.data!.user.latitude),
                      lng: double.parse(_model.data!.user.longitude),
                    ),
                  ),
                  Booster.verticalSpace(30),
                  Booster.paddedWidget(
                    left: 18,
                    right: 18,
                    child: Booster.dynamicFontSize(
                        isAlignCenter: false,
                        fontWeight: FontWeight.w400,
                        label: _model.data!.user.bio,
                        fontSize: 18,
                        color: FrontEndConfigs.darkTextColor),
                  ),
                  Booster.verticalSpace(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          print(_model.data!.user.facebook);
                          launchURL(_model.data!.user.facebook);
                        },
                        child: Image.asset(
                          'assets/images/fb.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launchURL(_model.data!.user.instagram);
                        },
                        child: Image.asset(
                          'assets/images/insta.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print(_model.data!.user.email);
                          launch(Uri(
                            scheme: "mailto",
                            path: _model.data!.user.email,
                            query: encodeQueryParameters(<String, String>{
                              'subject':
                                  'Example Subject & Symbols are allowed!'
                            }),
                          ).toString());
                        },
                        child: Image.asset(
                          'assets/images/email.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _showDialog(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 50));

    showDialog(
        context: context,
        barrierColor: Color(0xe683B2F5),
        builder: (BuildContext context) {
          final height = MediaQuery.of(context).size.height;
          return Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.33),
              child: Container(
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 56),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Booster.dynamicFontSize(
                                      label: "أحمد خليل عثمان",
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600),
                                  Booster.dynamicFontSize(
                                      label: "شارع الإرسال، رام الله",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                  Booster.verticalSpace(25),
                                  Container(
                                    height: 58,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DialogBoxContainer(
                                            icon: Icons.location_on),
                                        DialogBoxContainer(icon: Icons.email),
                                        DialogBoxContainer(icon: Icons.call),
                                      ],
                                    ),
                                  ),
                                  Booster.verticalSpace(20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                        top: -60,
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Booster.localProfileAvatar(
                                radius: 110,
                                assetImage: "assets/images/dp.png"))),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
