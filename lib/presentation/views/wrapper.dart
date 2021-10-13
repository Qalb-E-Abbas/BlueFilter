import 'package:blue_filter/application/auth_state.dart';
import 'package:blue_filter/presentation/views/bottom_nav_bar_view.dart';
import 'package:blue_filter/presentation/views/select_type_view.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoggedIn = false;

  Future<bool?> getUserLoginState() async {
    return await UserLoginStateHandler.getUserLoggedInSharedPreference();
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserLoginState().then((value) {
      if (value == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = value;
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? BottomNavbarView(
            index: 0,
            fromOutside: true,
          )
        : SelectTypeView();
  }
}
