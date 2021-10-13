import 'package:booster/booster.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  AppButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xffFFCC00),
                Color(0xffFFCC00),
                Color(0xffFFCC00),
                Color(0xe2f89545),
              ],
            )),
        child: Center(
            child: Booster.dynamicFontSize(
                label: label, fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
