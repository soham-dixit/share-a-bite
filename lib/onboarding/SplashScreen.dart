import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isLogoAnimationCompleted = false;

  showLogo() {
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.linear),
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isLogoAnimationCompleted) {
        _isLogoAnimationCompleted = true;
        _navigate();
      }
    });
  }

  void _navigate() async {
    DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    if (uid == null) {
      // UID is not set, navigate to the carousel page
      Get.offNamed('/carousel');
    } else {
      DatabaseEvent snapshot =
          await databaseRef.child('restaurants').child(uid).once();

      if (snapshot.snapshot.value != null) {
        Get.offNamed('/RestroHome');
      } else {
        // Get.offNamed('/carousel');
        DatabaseEvent snapshot =
            await databaseRef.child('ngo').child(uid).once();
        if (snapshot.snapshot.value != null) {
          Get.offNamed('/NgoHome');
        } else {
          DatabaseEvent snapshot =
              await databaseRef.child('grocery').child(uid).once();

          if (snapshot.snapshot.value != null) {
            Get.offNamed('/GroceryHome');
          } else {
            DatabaseEvent snapshot =
                await databaseRef.child('recycling_units').child(uid).once();
            if (snapshot.snapshot.value != null) {
              Get.offNamed('/RuHome');
            } else {
              DatabaseEvent snapshot = await databaseRef
                  .child('volunteers')
                  .child(uid)
                  .once();
              if (snapshot.snapshot.value != null) {
                Get.offNamed('/VolHome');
              } else {
                DatabaseEvent snapshot = await databaseRef
                    .child('recycling_units')
                    .child('delivery_exe')
                    .child(uid)
                    .once();
                if (snapshot.snapshot.value != null) {
                  // Get.offNamed('/DeliveryExeHome');
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    showLogo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Stack(
        children: [
          Positioned(
            top: screenSize.height / 2 - 200, // Center vertically
            left: screenSize.width / 2 - 150, // Center horizontally
            child: SlideTransition(
              position: _slideAnimation,
              child: Image.asset(
                'assets/logo/logo.png',
                width: 300,
                height: 300,
              ),
            ),
          ),
          Positioned(
            top: screenSize.height / 2 - 100, // Position below the logo
            left: screenSize.width / 2 - 175, // Center horizontally
            child: Image.asset(
              'assets/logo/text.png',
              width: 350,
              height: 350,
            ),
          ),
        ],
      ),
    );
  }
}
