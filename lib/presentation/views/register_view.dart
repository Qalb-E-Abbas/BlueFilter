import 'package:blue_filter/application/errorStrings.dart';
import 'package:blue_filter/application/user_type.dart';
import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/services/auth_services.dart';
import 'package:blue_filter/presentation/elements/app_button.dart';
import 'package:blue_filter/presentation/elements/authTextField.dart';
import 'package:blue_filter/presentation/elements/dialog.dart';
import 'package:blue_filter/presentation/elements/navigation_dialog.dart';
import 'package:blue_filter/presentation/elements/rich_text.dart';
import 'package:blue_filter/presentation/views/login_view.dart';
import 'package:blue_filter/validation/navigation_constant.dart';
import 'package:blue_filter/validation/validation_handler.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _pwdController = TextEditingController();

  TextEditingController _nameController = TextEditingController();

  AuthServices _authServices = AuthServices();

  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

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
    return Form(
      key: _formKey,
      child: LoadingOverlay(
        isLoading: authStatus.status == AuthState.Authenticating,
        progressIndicator: CircularProgressIndicator(),
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                        (route) => false);
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
                Booster.verticalSpace(60),
                Booster.dynamicFontSize(
                    label: "Register_Title".tr(),
                    fontSize: 18,
                    color: Colors.white),
                Booster.verticalSpace(20),
                AuthTextField(
                    label: "name_hint".tr(),
                    controller: _nameController,
                    onEditingComplete: () {},
                    validator: (val) =>
                        val!.isEmpty ? "Empty_Field".tr() : null),
                Booster.verticalSpace(15),
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Field cannot be empty";
                      } else if (val.length < 8) {
                        return "Password length cannnot be less than 8";
                      } else {
                        return null;
                      }
                    },
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
                Booster.verticalSpace(36),
                AppButton(
                  label: "register_button".tr(),
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _signUpUser(authStatus, context);
                  },
                ),
                Booster.verticalSpace(10),
                _signUpRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpRow(BuildContext context) {
    return CustomRichText(
      firstText: "already_account".tr(),
      tappableText: "sign_in_button".tr(),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginView()));
      },
    );
  }

  _signUpUser(AuthServices authStatus, BuildContext context) async {
    var userType = Provider.of<UserType>(context, listen: false);
    print(userType.getUserType());
    await authStatus.signUpUser(context,
        name: _nameController.text,
        email: _emailController.text,
        password: _pwdController.text,
        type: userType.getUserType());

    if (authStatus.status == AuthState.UnAuthenticated) {
      showErrorDialog(context,
          message: Provider.of<ErrorString>(context, listen: false)
              .getErrorString());
    } else if (authStatus.status == AuthState.Authenticated) {
      if (userType.getUserType() == "service_provider") {
        showNavigationDialog(context,
            message: "under_review".tr(),
            buttonText: "Message_Success_Button".tr(), navigation: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginView()));
        }, secondButtonText: "secondButtonText", showSecondButton: false);
      } else {
        showNavigationDialog(context,
            message: "Message_Success_Register".tr(),
            buttonText: "Message_Success_Button".tr(), navigation: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginView()));
        }, secondButtonText: "secondButtonText", showSecondButton: false);
      }
    } else {
      showErrorDialog(context,
          message: Provider.of<ErrorString>(context, listen: false)
              .getErrorString());
    }
  }
}
