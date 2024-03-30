import 'package:flutter/material.dart';
import 'package:movies_and_series_app/core/constants.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.icon,
    required this.labelText,
  });

  String labelText;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Center(
        child: TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            prefixIconColor: Constants.appsLighterMainColor,
            enabledBorder: Constants.border,
            border: Constants.border,
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}
