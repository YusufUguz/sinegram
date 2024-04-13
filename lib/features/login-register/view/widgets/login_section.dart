import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_and_series_app/widgets/custom_button.dart';
import 'package:movies_and_series_app/widgets/custom_textformfield.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo4clipped.png",
                    height: 150,
                  ),
                  CustomTextFormField(
                    icon: FontAwesomeIcons.envelope,
                    labelText: "E-Posta",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                      icon: FontAwesomeIcons.lock, labelText: "Şifre"),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    text: "Giriş Yap",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Şifremi Unuttum"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
