import 'dart:io';

import 'package:blue_filter/application/auth_state.dart';
import 'package:blue_filter/application/errorStrings.dart';
import 'package:blue_filter/application/name_state.dart';
import 'package:blue_filter/application/password_state.dart';
import 'package:blue_filter/application/user_type.dart';
import 'package:blue_filter/application/user_type_state.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/services/auth_services.dart';
import 'package:blue_filter/infrastructure/services/profile_services.dart';
import 'package:blue_filter/presentation/elements/app_button.dart';
import 'package:blue_filter/presentation/elements/authTextField.dart';
import 'package:blue_filter/presentation/elements/dialog.dart';
import 'package:blue_filter/presentation/elements/rich_text.dart';
import 'package:blue_filter/presentation/views/account_hold_on.dart';
import 'package:blue_filter/presentation/views/bottom_nav_bar_view.dart';
import 'package:blue_filter/presentation/views/normal_user_edit_view.dart';
import 'package:blue_filter/presentation/views/register_view.dart';
import 'package:blue_filter/presentation/views/service_provider_edit_view.dart';
import 'package:blue_filter/validation/navigation_constant.dart';
import 'package:blue_filter/validation/validation_handler.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _pwdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  final LocalStorage storage = new LocalStorage(BackendConfigs.localDB);
  bool _passwordVisible = false;
  UserTypeProvider _userTypeProvider = UserTypeProvider();
  ProfileServices _profileServices = ProfileServices();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getUI(context),
    );
  }

  Widget _getUI(BuildContext context) {
    var authStatus = Provider.of<AuthServices>(context);

    return LoadingOverlay(
      isLoading: authStatus.status == AuthState.Authenticating,
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
                    exit(0);
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
                    label: "sign_in_button".tr(),
                    fontSize: 18,
                    color: Colors.white),
                Booster.verticalSpace(20),
                AuthTextField(
                    label: "email_hint".tr(),
                    controller: _emailController,
                    onEditingComplete: () {},
                    validator: (val) => ValidationHandler.validateInput(
                        returnString: ValidationConstant.emptyEmail,
                        inputValue: val)),
                Booster.verticalSpace(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    controller: _pwdController,
                    obscureText: !_passwordVisible,
                    validator: (val) =>
                        val!.isEmpty ? "Empty_Field".tr() : null,
                    //This will obscure text dynamically
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: FrontEndConfigs.textFieldColor,
                      hintText: 'Enter_Password'.tr(),
                      hintStyle: TextStyle(color: FrontEndConfigs.hintColor),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: FrontEndConfigs.textFieldColor),
                        borderRadius: BorderRadius.circular(70.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: FrontEndConfigs.textFieldColor),
                        borderRadius: BorderRadius.circular(70.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: FrontEndConfigs.textFieldColor),
                        borderRadius: BorderRadius.circular(70.0),
                      ),
                      // focusedErrorBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(
                      //         color: Theme.of(context)
                      //             .inputDecorationTheme
                      //             .errorBorder
                      //             .borderSide
                      //             .color)),
                      // errorBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(
                      //         color: Theme.of(context)
                      //             .inputDecorationTheme
                      //             .errorBorder
                      //             .borderSide
                      //             .color)),
                      // enabledBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(
                      //         color: Theme.of(context)
                      //             .inputDecorationTheme
                      //             .border
                      //             .borderSide
                      //             .color)),
                    ),
                  ),
                ),
                Booster.verticalSpace(10),
                context.locale == Locale("en")
                    ? _getEnForgotPwdRow()
                    : _getArForgotPwdRow(),
                Booster.verticalSpace(45),
                AppButton(
                  label: "sign_in_button".tr(),
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    _loginUser(authStatus);
                  },
                ),
                Booster.verticalSpace(15),
                _signUpRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getArForgotPwdRow() {
    var authStatus = Provider.of<AuthServices>(context);
    return Booster.paddedWidget(
      left: 28,
      right: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Booster.dynamicFontSize(
                  fontFamily: "Tajawal",
                  label: "remember_me".tr(),
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              Booster.horizontalSpace(4),
              InkWell(
                onTap: () {
                  isChecked = !isChecked;
                  setState(() {});
                },
                child: Icon(
                  isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _initFcm(String? authToken) async {
    print("asklfjsdkl");
    _firebaseMessaging.getToken().then((token) {
      print("Device Token : $token");
      _profileServices.addToken(context,
          deviceToken: token!, authToken: authToken!);
    });
  }

  Widget _getEnForgotPwdRow() {
    return Booster.paddedWidget(
      left: 28,
      right: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  isChecked = !isChecked;
                  setState(() {});
                },
                child: Icon(
                  isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                  color: Colors.white,
                ),
              ),
              Booster.dynamicFontSize(
                  label: "remember_me".tr(),
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              Booster.horizontalSpace(4),
              Container(
                height: 1,
                width: 1,
              )
            ],
          ),
          Booster.horizontalSpace(10),
        ],
      ),
    );
  }

  Widget _signUpRow() {
    return CustomRichText(
      firstText: "no_account".tr(),
      tappableText: "register_button".tr(),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterView()));
      },
    );
  }

  _loginUser(AuthServices authStatus) async {
    var userType = Provider.of<UserType>(context, listen: false);
    print(userType.getUserType());
    await authStatus
        .loginUser(context,
            email: _emailController.text,
            password: _pwdController.text,
            type: userType.getUserType())
        .then((value) async {
      if (authStatus.status == AuthState.UnAuthenticated) {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      } else if (authStatus.status == AuthState.Authenticated) {
        PasswordState.saveUserPasswordSharedPreference(_pwdController.text);
        UserNameState.saveUserEmailSharedPreference(_emailController.text);
        if (isChecked) {
          UserLoginStateHandler.saveUserLoggedInSharedPreference(true);
          _userTypeProvider.saveUserType("service_provider");
        }
        _initFcm(value?.data!.token.toString());
        print(authStatus.user);
        await storage.setItem(BackendConfigs.loginUserData, authStatus.user);
        if (value?.data!.user.type == "service_provider") {
          if (value?.data!.user.isApproved == "0") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AccountHoldOn()));
          } else if (value?.data!.user.profileCompleted == "1") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomNavbarView(
                          index: 0,
                          fromOutside: true,
                        )));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ServiceProviderEditView()));
          }
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => BottomNavbarView()));
        } else {
          if (value?.data!.user.profileCompleted == "1") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BottomNavbarView(index: 0, fromOutside: true)));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => NormalUserEditView()));
          }
        }
      } else {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      }
    });
  }
}
