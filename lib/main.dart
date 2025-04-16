import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:vsc/screens/contect_screen.dart';
import 'package:vsc/screens/first_screen.dart';
import 'package:vsc/screens/help_screen.dart';
import 'package:vsc/screens/onboarding_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        FirstScreen.routeName: (context) => FirstScreen(),
        ContectScreen.routeName: (context) => ContectScreen(
        ),
        HelpScreen.routeName: (context) => HelpScreen(),

      },
    );
  }
}
