import 'package:blue_filter/application/auth_state.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:blue_filter/infrastructure/models/pages_model.dart';
import 'package:blue_filter/infrastructure/services/pages_services.dart';
import 'package:blue_filter/presentation/views/contact_us.dart';
import 'package:blue_filter/presentation/views/page_details.dart';
import 'package:blue_filter/presentation/views/select_type_view.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  PagesServices _pagesServices = PagesServices();

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
                          email: "",
                          name: items['data']['user']['name'],
                          type: "",
                          locale: items['data']['user']['locale'],
                          profileCompleted: "",
                          category: items['data']['user']['category'],
                          profileImage: "",
                          profileThumbnail: "",
                          service_provider_clicks: items['data']['user']
                              ['service_provider_clicks'],
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
    return Drawer(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xff58A0FF),
            Color(0xff58A0FF),
            Color(0xff2068E3),
          ])),
      child: Column(
        children: [
          Booster.verticalSpace(100),
          FutureProvider.value(
            value: _pagesServices.getPosts(context,
                authToken: _userModel.data!.token, pageNo: 1),
            initialData: PagesModel(),
            builder: (context, child) {
              return context.watch<PagesModel>().data == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: context.watch<PagesModel>().data!.length,
                      itemBuilder: (ctxt, i) {
                        return _createDrawerItem(
                            icon: Icons.email,
                            text: context
                                .watch<PagesModel>()
                                .data![i]
                                .title
                                .toString(),
                            onTap: () {
                              Datum pageDetails =
                                  context.read<PagesModel>().data![i];
                              setState(() {});
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PageDetailsViewer(
                                            pageDetails: pageDetails,
                                          )));
                            });
                      });
            },
          ),
          _createDrawerItem(
              icon: Icons.exit_to_app,
              text: 'contact_us',
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUs()),
                );
              }),
          _createDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Account_verificiation_Button',
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();

                UserLoginStateHandler.saveUserLoggedInSharedPreference(false);
                preferences.clear();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SelectTypeView()),
                    (route) => false);
              }),
          Booster.verticalSpace(10),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  FontAwesomeIcons.facebookF,
                  color: Colors.white,
                ),
                Icon(
                  FontAwesomeIcons.instagram,
                  color: Colors.white,
                ),
                Icon(
                  FontAwesomeIcons.twitter,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Booster.verticalSpace(40),
        ],
      ),
    )
        // ListView(
        //   padding: EdgeInsets.zero,
        //   children: <Widget>[
        //     Booster.verticalSpace(100),
        //     // _createDrawerItem(
        //     //     icon: FontAwesomeIcons.solidCompass,
        //     //     text: 'service_provider',
        //     //     onTap: () {
        //     //       Navigator.push(
        //     //           context,
        //     //           MaterialPageRoute(
        //     //               builder: (context) => BottomNavbarView(
        //     //                     index: 1,
        //     //                     fromOutside: true,
        //     //                   )));
        //     //     }),
        //
        //
        //     _createDrawerItem(
        //         icon: FontAwesomeIcons.solidBell,
        //         text: 'toward_clean_water',
        //         onTap: () {}),
        //     _createDrawerItem(
        //         icon: FontAwesomeIcons.image, text: 'save_water', onTap: () {}),
        //     _createDrawerItem(
        //         icon: FontAwesomeIcons.video,
        //         text: 'water_resource',
        //         onTap: () {}),
        //     // _createDrawerItem(
        //     //     icon: FontAwesomeIcons.mapMarker,
        //     //     text: 'settings',
        //     //     onTap: () {
        //     //       Navigator.push(
        //     //           context,
        //     //           MaterialPageRoute(
        //     //               builder: (context) => BottomNavbarView(
        //     //                     index: 3,
        //     //                     fromOutside: true,
        //     //                   )));
        //     //     }),

        );
  }

  Widget _createDrawerItem(
      {IconData? icon,
      required String text,
      required GestureTapCallback onTap,
      String? iconString}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12),
            child: Text(
              text.tr(),
              style: TextStyle(color: Colors.white, fontFamily: "Tajawal"),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
