import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/grocery_store/GroceryRegister.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroceryLogin extends StatefulWidget {
  const GroceryLogin({super.key});

  @override
  State<GroceryLogin> createState() => _GroceryLoginState();
}

class _GroceryLoginState extends State<GroceryLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Position? _currentPosition;
  String latitude = '';
  String longitude = '';
  String? uid = '';

  final formKey = GlobalKey<FormState>();

  final emailValidator = MultiValidator([
    EmailValidator(errorText: 'Please enter a valid email ID'),
    RequiredValidator(errorText: 'Please enter an email ID')
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Password must have at least one special character')
  ]);

  List inputs = [];

  navigateToRegister() {
    Get.to(const GroceryRegister());
  }

  navigateToHome() async {
    Get.offAllNamed('/GroceryHome');
    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser?.uid);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', FirebaseAuth.instance.currentUser!.uid);
    }
  }

  groceryLogin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        'Login Successful!',
        'You have been logged in successfully',
      );
      setUid();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Get.snackbar(
          'Error!',
          'No user found for this email',
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Get.snackbar(
          'Error!',
          'Wrong password provided for this user',
        );
      }
    }
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
          .child('grocery')
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

  checkEmailExists(String email, String password) async {
    final restaurantsRef = FirebaseFirestore.instance.collection('grocery');
    final querySnapshot =
        await restaurantsRef.where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isEmpty) {
      Get.snackbar("Error!", "Please register your account");
    } else {
      groceryLogin(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 10,
              horizontal: MediaQuery.of(context).size.width / 15),
          child: Column(
            children: [
              const SizedBox(
                height: 18,
              ),
              const Text(
                'Login as Grocery Store',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SvgPicture.asset(
                'assets/users/grocery.svg',
                height: 100,
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
                        keyboardType: TextInputType.name,
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
                        // validator: passwordValidator,
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
                            groceryLogin(_emailController.text,
                                _passwordController.text);
                            // checkEmailExists(_emailController.text,
                            //     _passwordController.text);
                            // await FirebaseAuth.instance.signOut();
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
                            'New user?',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            onTap: navigateToRegister,
                            child: const Text(
                              ' Register now',
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
