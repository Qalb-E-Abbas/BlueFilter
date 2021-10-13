import 'package:blue_filter/application/app_state.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/enums.dart';
import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:blue_filter/infrastructure/services/contact_us_services.dart';
import 'package:blue_filter/presentation/elements/app_button.dart';
import 'package:blue_filter/presentation/elements/dialog.dart';
import 'package:blue_filter/presentation/elements/navigation_dialog.dart';
import 'package:blue_filter/presentation/views/bottom_nav_bar_view.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ContactUsServices _contactUsServices = ContactUsServices();
  late SuccessfulLoginModel userModel;
  final LocalStorage storage = new LocalStorage(BackendConfigs.localDB);
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  bool initialized = false;

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
              : Scaffold(
                  body: _getUI(context, userModel),
                );
        });
  }

  Widget _getUI(BuildContext context, SuccessfulLoginModel _userModel) {
    var status = Provider.of<AppState>(context);
    return LoadingOverlay(
      isLoading: status.getStateStatus() == AppCurrentState.IsBusy,
      progressIndicator: CircularProgressIndicator(),
      child: Form(
        key: _formKey,
        child: Container(
          height: Booster.screenHeight(context),
          width: Booster.screenWidth(context),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/blur_bg.png'))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Booster.verticalSpace(50),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Booster.paddedWidget(
                    right: 20,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset('assets/images/arrow.png',
                          height: 25, width: 30),
                    ),
                  ),
                ),
                Booster.verticalSpace(80),
                Booster.dynamicFontSize(
                    label: "contact_us".tr(),
                    fontSize: 18,
                    color: Colors.white),
                Booster.verticalSpace(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                    controller: _subjectController,
                    validator: (val) =>
                        val!.isEmpty ? "Empty_Field".tr() : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: FrontEndConfigs.textFieldColor,
                      hintText: "subject".tr(),
                      hintStyle: TextStyle(color: FrontEndConfigs.hintColor),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: FrontEndConfigs.textFieldColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: FrontEndConfigs.textFieldColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: FrontEndConfigs.textFieldColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Booster.verticalSpace(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                    maxLines: 4,
                    controller: _messageController,
                    validator: (val) =>
                        val!.isEmpty ? "Empty_Field".tr() : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: FrontEndConfigs.textFieldColor,
                      hintText: "message".tr(),
                      hintStyle: TextStyle(color: FrontEndConfigs.hintColor),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: FrontEndConfigs.textFieldColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: FrontEndConfigs.textFieldColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: FrontEndConfigs.textFieldColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Booster.verticalSpace(10),
                Booster.verticalSpace(45),
                AppButton(
                  label: "send_query".tr(),
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    _contactUsServices
                        .contactUs(context,
                            subject: _subjectController.text,
                            message: _messageController.text,
                            authToken: _userModel.data!.token)
                        .then((value) {
                      if (status.getStateStatus() == AppCurrentState.IsFree) {
                        showNavigationDialog(context,
                            message: "query_sent".tr(),
                            buttonText: "Message_Success_Button".tr(),
                            navigation: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomNavbarView(
                                        fromOutside: true,
                                        index: 1,
                                      )),
                              (route) => false);
                        }, secondButtonText: "", showSecondButton: false);
                      } else if (status.getStateStatus() ==
                          AppCurrentState.IsError) {
                        showErrorDialog(context, message: "facing_issue");
                      }
                    });
                  },
                ),
                Booster.verticalSpace(15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
