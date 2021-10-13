import 'package:blue_filter/application/errorStrings.dart';
import 'package:blue_filter/application/user_type.dart';
import 'package:blue_filter/infrastructure/services/auth_services.dart';
import 'package:blue_filter/presentation/elements/app_button.dart';
import 'package:blue_filter/presentation/elements/authTextField.dart';
import 'package:blue_filter/presentation/elements/dialog.dart';
import 'package:blue_filter/presentation/elements/navigation_dialog.dart';
import 'package:blue_filter/presentation/views/login_view.dart';
import 'package:blue_filter/validation/navigation_constant.dart';
import 'package:blue_filter/validation/validation_handler.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                Booster.verticalSpace(130),
                Booster.dynamicFontSize(
                    label: "password_recovery".tr(),
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
                Booster.verticalSpace(100),
                AppButton(
                  label: "recover".tr(),
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _resetPassword(authStatus, context);
                  },
                ),
                Booster.verticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _resetPassword(AuthServices authStatus, BuildContext context) async {
    var userType = Provider.of<UserType>(context, listen: false);
    await authStatus
        .resetPassword(context,
            email: _emailController.text, type: userType.getUserType())
        .then((value) {
      if (authStatus.status == AuthState.UnAuthenticated) {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      } else if (authStatus.status == AuthState.Authenticated) {
        showNavigationDialog(context,
            message: value!.message, buttonText: "Go To Login", navigation: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginView()));
        }, secondButtonText: "secondButtonText", showSecondButton: false);
      } else {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      }
    });
  }
}
