import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_and_series_app/widgets/custom_button.dart';
import 'package:movies_and_series_app/widgets/custom_checkbox.dart';
import 'package:movies_and_series_app/widgets/custom_textformfield.dart';

class RegisterSection extends StatelessWidget {
  const RegisterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                      icon: FontAwesomeIcons.user, labelText: "Kullanıcı Adı"),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                      icon: FontAwesomeIcons.envelope, labelText: "E-Posta"),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                      icon: FontAwesomeIcons.lock, labelText: "Şifre"),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                      icon: FontAwesomeIcons.lock, labelText: "Şifre Tekrar"),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: CustomCheckBox(),
                  ),
                  CustomButton(text: "Kayıt Ol"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
