import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/CommonWidgets.dart';

class NgoOpLogin extends StatefulWidget {
  const NgoOpLogin({super.key});

  @override
  State<NgoOpLogin> createState() => _NgoOpLoginState();
}

class _NgoOpLoginState extends State<NgoOpLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? uid = '';
  String? _currentAddress;
  Position? _currentPosition;
  String latitude = '';
  String longitude = '';

  final formKey = GlobalKey<FormState>();

  final emailValidator = MultiValidator([
    EmailValidator(errorText: 'Please enter a valid email ID'),
    RequiredValidator(errorText: 'Please enter an email ID')
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter a password'),
    MinLengthValidator(6, errorText: 'Minimum 6 characters'),
    PatternValidator(
      r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])',
      errorText: 'Letters, numbers, and at least one special character',
    ),
  ]);

  registerNgo() {
    Get.toNamed('/NgoRegister');
  }

  setUid() async {
    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser?.uid);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', FirebaseAuth.instance.currentUser!.uid);
      uid = prefs.getString('uid');
      print(uid);
      _getCurrentPosition();
    }
  }

  navigateToHome() async {
    Get.offAllNamed('/NgoHome');
  }

  NgoOpLogin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        'Login successful!',
        'You have been logged in successfully',
      );
      setUid();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email');
        Get.snackbar(
          'Error!',
          'No user found for this email',
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for this user');
        Get.snackbar(
          'Error!',
          'Wrong password provided for this user.',
        );
      }
    }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      // latitude = _currentPosition!.latitude.toString();
      // longitude = _currentPosition!.longitude.toString();
      final intLatitude = _currentPosition!.latitude.toDouble();
      final intLongitude = _currentPosition!.longitude.toDouble();
      // store latitude and longitude in realtime database
      final databaseReference = FirebaseDatabase.instance.ref();
      databaseReference
          .child('ngo')
          .child(uid!)
          .update({'latitude': intLatitude, 'longitude': intLongitude});
      navigateToHome();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  // checkEmailExists(String email, String password) async {
  //   final restaurantsRef = FirebaseFirestore.instance.collection('ngo');
  //   final querySnapshot =
  //       await restaurantsRef.where('email', isEqualTo: email).get();
  //   if (querySnapshot.docs.isEmpty) {
  //     Get.snackbar("Error!", "Please register your account");
  //   } else {
  //     NgoOpLogin(email, password);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 15,
              horizontal: MediaQuery.of(context).size.width / 15),
          child: Column(
            children: [
              const SizedBox(
                height: 18,
              ),
              const Text(
                'Login as NGO Operator',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SvgPicture.asset(
                'assets/users/ngo.svg',
                height: 120,
                width: 120,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Enter your credentials",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  // fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          // fontWeight: FontWeight.bold,
                        ),
                        validator: emailValidator,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          label: Text('Email ID'),
                          labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          // fontWeight: FontWeight.bold,
                        ),
                        obscureText: true,
                        validator: passwordValidator,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          label: Text('Password'),
                          labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      MainButton(
                        initialTitle: 'Login',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // inputs = [
                            //   _emailController.text,
                            //   _passwordController.text
                            // ];
                            NgoOpLogin(_emailController.text,
                                _passwordController.text);
                            // checkEmailExists(_emailController.text,
                            //     _passwordController.text);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Register as',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            onTap: registerNgo,
                            child: const Text(
                              ' NGO?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                                color: Color(0xFFF23F44),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
