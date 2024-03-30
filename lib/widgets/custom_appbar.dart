import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        "assets/images/logo4.png",
        width: 150,
        height: 150,
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.magnifyingGlass))
      ],
    );
  }
}
