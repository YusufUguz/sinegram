import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_and_series_app/features/login-register/view/login_register_page.dart';
import 'package:movies_and_series_app/features/profile/view/widgets/profile_page_list_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.circleExclamation),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Listeler oluşturmak ve yorum yapabilmek için giriş yapmalısınız.",
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA1C9FF)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginRegisterPage();
                  }));
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Giriş Yap / Kayıt Ol",
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ProfilePageListTile(
                text: "Bize Yazın", icon: FontAwesomeIcons.envelope),
            ProfilePageListTile(
                text: "Hakkımızda", icon: FontAwesomeIcons.info),
          ],
        ),
      ),
    );
  }
}
