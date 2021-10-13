import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:blue_filter/infrastructure/models/nearby_service_provider.dart';
import 'package:blue_filter/infrastructure/services/profile_services.dart';
import 'package:blue_filter/presentation/elements/appDrawer.dart';
import 'package:blue_filter/presentation/elements/dialog_box_container.dart';
import 'package:blue_filter/presentation/elements/google_map.dart';
import 'package:blue_filter/presentation/elements/icon_row.dart';
import 'package:blue_filter/presentation/elements/text_contaier.dart';
import 'package:blue_filter/presentation/helper/url_launcher_helper.dart';
import 'package:booster/booster.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceProviderProfile extends StatelessWidget {
  final Datum _model;

  ServiceProviderProfile(this._model);

  final LocalStorage storage = new LocalStorage(BackendConfigs.localDB);

  bool initialized = false;

  late SuccessfulLoginModel userModel;
  ProfileServices _profileServices = ProfileServices();

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
                          email: "",
                          name: items['data']['user']['name'],
                          service_provider_clicks: items['data']['user']
                              ['service_provider_clicks'],
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

  Widget _getCreateUI(BuildContext context, SuccessfulLoginModel _userModel) {
    return Scaffold(
      body: _getUI(context, _userModel),
      drawer: AppDrawer(),
    );
  }

  Widget _getUI(BuildContext context, SuccessfulLoginModel model) {
    print(_model.category);
    return Container(
      height: Booster.screenHeight(context),
      width: Booster.screenWidth(context),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/splashBG.png'))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Booster.verticalSpace(70),
          Booster.paddedWidget(
            right: 20,
            left: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Booster.dynamicFontSize(
                    label: "service_provider".tr(),
                    fontSize: 20,
                    color: Colors.white),
                Builder(
                  builder: (context) {
                    return InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 19,
                      ),
                    );
                  },
                )
              ],
            ),
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
                              label: _model.name,
                              fontSize: 26,
                            ),
                            Booster.verticalSpace(5),
                            IconRow(
                                title: _model.address, icon: Icons.location_on),
                            Booster.verticalSpace(5),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            print(_model.id);
                            _profileServices.incrementCounter(context,
                                id: int.parse(
                                  _model.id.toString(),
                                ),
                                authToken: model.data!.token);
                            _showDialog(context);
                          },
                          child: Image.asset(
                            'assets/images/call.png',
                            height: 69,
                            width: 58,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Booster.verticalSpace(20),
                  if (_model.category.isNotEmpty)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      children: [
                        ..._model.category
                            .asMap()
                            .map((i, element) => MapEntry(
                                i,
                                TextContainer(
                                    text: userModel.data!.user.locale == "en"
                                        ? element['name']
                                        : element['name_ar'])))
                            .values
                            .toList(),
                      ],
                    ),
                  Booster.verticalSpace(30),
                  Container(
                    height: 190,
                    child: GetMapView(
                      lng: double.parse(_model.longitude),
                      lat: double.parse(_model.latitude),
                    ),
                  ),
                  Booster.verticalSpace(30),
                  Booster.paddedWidget(
                    left: 18,
                    right: 18,
                    child: Booster.dynamicFontSize(
                        isAlignCenter: false,
                        fontWeight: FontWeight.w400,
                        label: _model.bio,
                        fontSize: 18,
                        color: FrontEndConfigs.darkTextColor),
                  ),
                  Booster.verticalSpace(40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          launchURL(_model.facebook);
                        },
                        child: Image.asset(
                          'assets/images/fb.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launchURL(_model.instagram);
                        },
                        child: Image.asset(
                          'assets/images/insta.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launch(Uri(
                            scheme: "mailto",
                            path: _model.email,
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
                                      label: _model.name.toString(),
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600),
                                  Booster.dynamicFontSize(
                                      label: _model.address.toString(),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                  Booster.verticalSpace(25),
                                  Container(
                                    height: 58,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            MapsLauncher.launchCoordinates(
                                                double.parse(_model.latitude),
                                                double.parse(_model.longitude));
                                          },
                                          child: DialogBoxContainer(
                                              icon: Icons.location_on),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              launch(Uri(
                                                scheme: "mailto",
                                                path: _model.email,
                                                query: encodeQueryParameters(<
                                                    String, String>{
                                                  'subject':
                                                      'Example Subject & Symbols are allowed!'
                                                }),
                                              ).toString());
                                            },
                                            child: DialogBoxContainer(
                                                icon: Icons.email)),
                                        InkWell(
                                            onTap: () {
                                              launch("tel://${_model.phone}");
                                            },
                                            child: DialogBoxContainer(
                                                icon: Icons.call)),
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
                    if (_model.profileImage != null)
                      Positioned.fill(
                          top: -60,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: _model.profileImage ?? "",
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                  ),
                                ),
                              ))),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
