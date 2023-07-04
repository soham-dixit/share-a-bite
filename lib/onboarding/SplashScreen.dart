import 'package:cloud_firestore/cloud_firestore.dart';
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

  _navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    if (uid == null) {
      // UID is not set, navigate to the carousel page
      Get.offNamed('/carousel');
    } else {
      // UID is set, check if it exists in the 'restaurants' collection
      DocumentSnapshot restaurantSnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(uid)
          .get();

      if (restaurantSnapshot.exists) {
        // UID exists in the 'restaurants' collection, navigate to the restaurants page
        Get.offNamed('/RestroHome');
      } else {
        // UID doesn't exist in the 'restaurants' collection, check if it exists in the 'ngo' collection
        DocumentSnapshot ngoSnapshot =
            await FirebaseFirestore.instance.collection('ngo').doc(uid).get();

        if (ngoSnapshot.exists) {
          // UID exists in the 'ngo' collection, navigate to the ngo page
          Get.offNamed('/NgoHome');
        } else {
          // UID doesn't exist in the 'ngo' collection, check if it exists in the 'grocery_stores' collection
          DocumentSnapshot grocerySnapshot = await FirebaseFirestore.instance
              .collection('grocery')
              .doc(uid)
              .get();
          if (grocerySnapshot.exists) {
            // UID exists in the 'grocery_stores' collection, navigate to the ngo page
            Get.offNamed('/GroceryHome');
          } else {
            // UID doesn't exist in the 'grocery_stores' collection, check if it exists in the 'recycling_units' collection
            DocumentSnapshot ruSnapshot = await FirebaseFirestore.instance
                .collection('recycling_units')
                .doc(uid)
                .get();
            if (ruSnapshot.exists) {
              // UID exists in the 'recycling_units' collection, navigate to the recycling unit page
              Get.offNamed('/RuHome');
            } else {
              Get.offNamed('/carousel');
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
