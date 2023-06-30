import 'package:flutter/material.dart';
import 'package:share_a_bite/onboarding/intro_carousel.dart';
import 'signup.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/carousel',
      routes: {
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/carousel':(context) => IntroCarousel(),
      },
    );
  }
}
