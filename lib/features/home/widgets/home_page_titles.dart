import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePageTitles extends StatelessWidget {
  HomePageTitles({super.key, required this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
