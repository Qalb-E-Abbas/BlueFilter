import 'dart:io';

import 'package:blue_filter/application/name_state.dart';
import 'package:blue_filter/application/password_state.dart';
import 'package:blue_filter/application/user_type.dart';
import 'package:blue_filter/application/user_type_state.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:blue_filter/infrastructure/services/auth_services.dart';
import 'package:blue_filter/presentation/elements/navigation_dialog.dart';
import 'package:blue_filter/presentation/views/home_page_view.dart';
import 'package:blue_filter/presentation/views/normal_user_edit_view.dart';
import 'package:blue_filter/presentation/views/search_page.dart';
import 'package:blue_filter/presentation/views/service_around_me.dart';
import 'package:blue_filter/presentation/views/service_provider_edit_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

/// This is the stateful widget that the main application instantiates.
class BottomNavbarView extends StatefulWidget {
  final int index;
  final bool fromOutside;

  const BottomNavbarView(
      {Key? key, required this.index, required this.fromOutside})
      : super(key: key);

  @override
  State<BottomNavbarView> createState() => _BottomNavbarViewState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomNavbarViewState extends State<BottomNavbarView> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  AuthServices _authServices = AuthServices();

  @override
  initState() {
    var userType = Provider.of<UserType>(context, listen: false);
    UserNameState.getUserEmailSharedPreference().then((email) {
      PasswordState.getPasswordSharedPreference().then((value) {
        _authServices
            .loginUser(context,
                email: email!, password: value!, type: userType.getUserType())
            .then((value) async {
          UserNameState.saveImage(value!.data!.user.profileImage);
          await storage.setItem(BackendConfigs.loginUserData, value);
        });
      });
    });

    super.initState();
  }

  Widget getPages({required SuccessfulLoginModel model, required int index}) {
    if (index == 0) {
      return HomePageView(model);
    } else if (index == 1) {
      return ServicesAroundMe();
    } else if (index == 2) {
      return ServiceProviderEditView();
    } else if (index == 3) {
      return SearchPage();
    } else {
      return Container();
    }
  }

  Widget getUserPages(
      {required SuccessfulLoginModel model, required int index}) {
    if (index == 0) {
      return HomePageView(model);
    } else if (index == 1) {
      return ServicesAroundMe();
    } else if (index == 2) {
      return NormalUserEditView();
    } else if (index == 3) {
      return SearchPage();
    } else {
      return Container();
    }
  }

  static List<Widget> _widgetOptions1 = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final LocalStorage storage = new LocalStorage(BackendConfigs.localDB);

  bool initialized = false;

  late SuccessfulLoginModel userModel;

  var userData;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showNavigationDialog(context,
            message: "exit_msj".tr(), buttonText: "yes".tr(), navigation: () {
          exit(0);
        }, secondButtonText: "no".tr(), showSecondButton: true);
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 2,
          onPressed: () {
            Share.share(
                'Check out my app on PlayStore : https://play.google.com/store/apps/details?id=com.com.example.blue_filter');
          },
          child: Icon(
            Icons.share,
            size: 19,
            color: Colors.black,
          ),
        ),
        body: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var items = storage.getItem(BackendConfigs.loginUserData);
              print("BOttom");

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
                            category: [],
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
                            service_provider_clicks: items['data']['user']
                                ['service_provider_clicks'],
                            address: items['data']['user']['address'],
                            distance: "")));
              }
              print(items);

              return snapshot.data == null
                  ? Center(child: CircularProgressIndicator())
                  : _getCreateUI(context, userModel);
            }),
      ),
    );
  }

  Widget _getCreateUI(BuildContext context, SuccessfulLoginModel _model) {
    var type = Provider.of<UserTypeProvider>(context);
    return Scaffold(
      body: Center(
        child: type.getUserType == "service_provider"
            ? getPages(model: _model, index: _selectedIndex)
            : getUserPages(model: _model, index: _selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: FrontEndConfigs.darkTextColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: '',
            icon: Padding(
              padding: context.locale == Locale('en')
                  ? EdgeInsets.only(right: 18.0)
                  : EdgeInsets.only(left: 18.0),
              child: Icon(
                FontAwesomeIcons.home,
                size: 17,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Padding(
              padding: context.locale == Locale('en')
                  ? EdgeInsets.only(right: 58.0)
                  : EdgeInsets.only(left: 58.0),
              child: Icon(
                FontAwesomeIcons.map,
                size: 17,
              ),
            ),
          ),
          // BottomNavigationBarItem(
          //   label: '',
          //   icon: Icon(
          //     FontAwesomeIcons.shareAlt,
          //     size: 17,
          //   ),
          // ),
          BottomNavigationBarItem(
            label: '',
            icon: Padding(
              padding: context.locale == Locale('en')
                  ? EdgeInsets.only(left: 58.0)
                  : EdgeInsets.only(right: 58.0),
              child: Icon(
                FontAwesomeIcons.cogs,
                size: 17,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Padding(
              padding: context.locale == Locale('en')
                  ? EdgeInsets.only(left: 18.0)
                  : EdgeInsets.only(right: 18.0),
              child: Icon(
                FontAwesomeIcons.search,
                size: 17,
              ),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: FrontEndConfigs.bgColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
