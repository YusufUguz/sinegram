// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_and_series_app/features/login-register/view/login_register_page.dart';
import 'package:movies_and_series_app/services/auth.dart';
import 'package:movies_and_series_app/widgets/custom_button.dart';
import 'package:movies_and_series_app/widgets/custom_checkbox.dart';
import 'package:movies_and_series_app/widgets/custom_textformfield.dart';

class RegisterSection extends StatefulWidget {
  RegisterSection({super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  State<RegisterSection> createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection> {
  final formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _passwordAgainController = TextEditingController();

  String? _errorTextForUsername;
  String? _errorTextForEmail;

  Future<void> _checkUsernameAvailability(String username) async {
    final usersCollection = widget._firestore.collection('users');
    final querySnapshot =
        await usersCollection.where('username', isEqualTo: username).get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _errorTextForUsername = 'Bu kullanıcı adı zaten kullanımda.';
      });
    } else {
      setState(() {
        _errorTextForUsername = null;
      });
    }
  }

  Future<void> _checkEmailAvailability(String email) async {
    final usersCollection = widget._firestore.collection('users');
    final querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _errorTextForEmail = 'Bu e-posta zaten kullanımda.';
      });
    } else {
      setState(() {
        _errorTextForEmail = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: CustomScrollView(
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
                        validator: (value) {
                          _checkUsernameAvailability(_usernameController.text);
                          if (value!.isEmpty) {
                            return 'Kullanıcı Adınızı Giriniz.';
                          } else if (_errorTextForUsername ==
                              'Bu kullanıcı adı zaten kullanımda.') {
                            return 'Bu kullanıcı adı zaten kullanımda.';
                          }
                          return null;
                        },
                        textEditingController: _usernameController,
                        icon: FontAwesomeIcons.user,
                        labelText: "Kullanıcı Adı"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                        validator: (value) {
                          _checkEmailAvailability(_emailController.text);
                          const pattern =
                              r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                          final regExp = RegExp(pattern);
                          if (value!.isEmpty) {
                            return 'E-Posta Giriniz';
                          } else if (!regExp.hasMatch(value)) {
                            return '@ ve .com bulunduran E-Posta Giriniz.';
                          } else if (_errorTextForEmail ==
                              'Bu e-posta zaten kullanımda.') {
                            return 'Bu e-posta zaten kullanımda.';
                          }
                          return null;
                        },
                        textEditingController: _emailController,
                        icon: FontAwesomeIcons.envelope,
                        labelText: "E-Posta"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                        obsecureText: true,
                        validator: (value) {
                          const pattern =
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-z\d@$!%*?&.]{8,}$';
                          final regExp = RegExp(pattern);

                          if (value!.isEmpty) {
                            return 'Şifrenizi Giriniz.';
                          } else if (!regExp.hasMatch(value)) {
                            return 'Şifreniz en az 1 büyük,1 küçük,1 özel karakter içermeli ve en az 8 haneli olmalıdır.';
                          }
                          return null;
                        },
                        textEditingController: _passwordController,
                        icon: FontAwesomeIcons.lock,
                        labelText: "Şifre"),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                        obsecureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Şifreler uyuşmuyor";
                          }
                          return null;
                        },
                        textEditingController: _passwordAgainController,
                        icon: FontAwesomeIcons.lock,
                        labelText: "Şifre Tekrar"),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: CustomCheckBox(),
                    ),
                    CustomButton(
                      text: "Kayıt Ol",
                      onPressed: () async {
                        final isValid = formKey.currentState?.validate();
                        if (isValid!) {
                          formKey.currentState?.save();
                          try {
                            await Auth().signUpWithEmailAndPassword(
                              context: context,
                              username: _usernameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text(
                                  "Kayıt Başarılı.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  "Kaydınız başarıyla tamamlandı.Giriş Sayfasına yönlendiriliyorsunuz.",
                                  style: TextStyle(
                                      fontFamily: 'Blogger_Sans', fontSize: 18),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) {
                                        return const LoginRegisterPage();
                                      }));
                                    },
                                    child: const Text(
                                      "Tamam",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            debugPrint(e.toString());
                          }
                        }
                        /* if (isValid == false) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text(
                                "Bilgileriniz Yanlış!",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                "Bilgileri doğru girdiğinizden emin olunuz.",
                                style: TextStyle(
                                    fontFamily: 'Blogger_Sans', fontSize: 18),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text(
                                    "Tamam",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } */
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
