// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:movies_and_series_app/core/color_schemes.g.dart';
import 'package:movies_and_series_app/core/constants.dart';
import 'package:movies_and_series_app/features/splash/splash_screen.dart';

void main() {
  runApp(const Sinegram());
}

class Sinegram extends StatelessWidget {
  const Sinegram({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sinegram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              actionsIconTheme:
                  IconThemeData(color: Constants.appsLighterMainColor),
              backgroundColor: Color(0xff24292F),
              elevation: 0,
              scrolledUnderElevation: 0)),
      home: const SplashScreen(),
    );
  }
}
