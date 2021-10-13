import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String?) validator;
  final bool isPasswordField;
  final bool showTrailing;
  final bool isVisible;
  final VoidCallback? onTrailingTap;
  final VoidCallback onEditingComplete;

  AuthTextField(
      {required this.label,
      required this.controller,
      this.onTrailingTap,
      this.showTrailing = false,
      this.isVisible = false,
      this.isPasswordField = false,
      required this.onEditingComplete,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        onEditingComplete: () => onEditingComplete(),
        controller: controller,
        obscureText: isPasswordField,
        validator: (val) => validator(val),
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.caption,
        decoration: InputDecoration(
          filled: true,
          fillColor: FrontEndConfigs.textFieldColor,
          hintText: label,
          hintStyle: TextStyle(color: FrontEndConfigs.hintColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: FrontEndConfigs.textFieldColor),
            borderRadius: BorderRadius.circular(70.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: FrontEndConfigs.textFieldColor),
            borderRadius: BorderRadius.circular(70.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: FrontEndConfigs.textFieldColor),
            borderRadius: BorderRadius.circular(70.0),
          ),
        ),
      ),
    );
  }
}
