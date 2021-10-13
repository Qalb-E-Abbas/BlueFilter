import 'package:blue_filter/presentation/elements/app_button.dart';
import 'package:blue_filter/presentation/elements/navigation_dialog.dart';
import 'package:blue_filter/presentation/views/login_view.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AccountHoldOn extends StatelessWidget {
  const AccountHoldOn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showNavigationDialog(context,
            message: "Account_verificiation_Content".tr(),
            buttonText: "Message_Success_Button".tr(), navigation: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginView()),
              (_) => false);
        }, secondButtonText: "secondButtonText", showSecondButton: false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            height: 1,
            width: 1,
          ),
          title: Text("Account_verificiation_Title".tr()),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Booster.dynamicFontSize(
                label: "Account_verificiation_Content".tr(),
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.grey),
            Booster.verticalSpace(30),
            AppButton(
              label: "Account_verificiation_Button".tr(),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
