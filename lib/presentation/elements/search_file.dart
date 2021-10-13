import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onSubmitted;

  SearchField({
    required this.label,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        onFieldSubmitted: (val) => onSubmitted(val),
        controller: controller,
        style: Theme.of(context).textTheme.caption,
        decoration: InputDecoration(
          filled: true,
          fillColor: FrontEndConfigs.textFieldColor,
          hintText: label,
          hintStyle: TextStyle(color: FrontEndConfigs.hintColor),
          suffixIcon: Icon(Icons.search),
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
