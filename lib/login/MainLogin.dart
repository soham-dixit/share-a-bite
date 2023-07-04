import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/login/GroceryLogin.dart';
import 'package:share_a_bite/login/GuestLogin.dart';
import 'package:share_a_bite/login/NgoVolLogin.dart';
import 'package:share_a_bite/login/RestroLogin.dart';
import 'package:share_a_bite/login/RuDeliveryLogin.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';

class MainLogin extends StatefulWidget {
  const MainLogin({super.key});

  @override
  State<MainLogin> createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  bool isRestroSelected = false;
  bool isGrocerySelected = false;
  bool isNgoSelected = false;
  bool isRuSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 80, bottom: 30),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: Constants.getScreenHeight(context) * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isRestroSelected = !isRestroSelected;

                          if (isGrocerySelected) {
                            isGrocerySelected = false;
                          }

                          if (isNgoSelected) {
                            isNgoSelected = false;
                          }

                          if (isRuSelected) {
                            isRuSelected = false;
                          }

                          // if (isButton1Selected ||
                          //     isButton2Selected ||
                          //     isButton3Selected) {
                          //   showSkipButton = false;
                          // }

                          // if (!isButton1Selected &&
                          //     !isButton2Selected &&
                          //     !isButton3Selected) {
                          //   showSkipButton = true;
                          // }
                        });
                      },
                      child: Container(
                        width: 171,
                        height: 171,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffff3333),
                            width: isRestroSelected ? 1.5 : 0.2,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/users/restro.svg',
                                height: 60,
                                width: 60,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Restaurants',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isGrocerySelected = !isGrocerySelected;

                          if (isRestroSelected) {
                            isRestroSelected = false;
                          }
                          if (isNgoSelected) {
                            isNgoSelected = false;
                          }
                          if (isRuSelected) {
                            isRuSelected = false;
                          }

                          // if (isButton1Selected ||
                          //     isButton2Selected ||
                          //     isButton3Selected) {
                          //   showSkipButton = false;
                          // }

                          // if (!isButton1Selected &&
                          //     !isButton2Selected &&
                          //     !isButton3Selected) {
                          //   showSkipButton = true;
                          // }
                        });
                      },
                      child: Container(
                        width: 171,
                        height: 171,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffff3333),
                            width: isGrocerySelected ? 1.5 : 0.2,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/users/grocery.svg',
                                height: 60,
                                width: 60,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Grocery',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isNgoSelected = !isNgoSelected;

                          if (isRestroSelected) {
                            isRestroSelected = false;
                          }
                          if (isGrocerySelected) {
                            isGrocerySelected = false;
                          }
                          if (isRuSelected) {
                            isRuSelected = false;
                          }

                          // if (isButton1Selected ||
                          //     isButton2Selected ||
                          //     isButton3Selected) {
                          //   showSkipButton = false;
                          // }

                          // if (!isButton1Selected &&
                          //     !isButton2Selected &&
                          //     !isButton3Selected) {
                          //   showSkipButton = true;
                          // }
                        });
                      },
                      child: Container(
                        width: 171,
                        height: 171,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffff3333),
                            width: isNgoSelected ? 1.5 : 0.2,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/users/ngo.svg',
                                height: 60,
                                width: 60,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'NGO',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isRuSelected = !isRuSelected;

                          if (isRestroSelected) {
                            isRestroSelected = false;
                          }
                          if (isGrocerySelected) {
                            isGrocerySelected = false;
                          }
                          if (isNgoSelected) {
                            isNgoSelected = false;
                          }

                          // if (isButton1Selected ||
                          //     isButton2Selected ||
                          //     isButton3Selected) {
                          //   showSkipButton = false;
                          // }

                          // if (!isButton1Selected &&
                          //     !isButton2Selected &&
                          //     !isButton3Selected) {
                          //   showSkipButton = true;
                          // }
                        });
                      },
                      child: Container(
                        width: 171,
                        height: 171,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffff3333),
                            width: isRuSelected ? 1.5 : 0.2,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/users/ru.svg',
                                height: 60,
                                width: 60,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Recycling Unit',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MainOrangeBorderButton(
                    initialTitle: 'Login as Guest?',
                    onPressed: () {
                      Get.to(() => const GuestLogin());
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MainButton(
                    initialTitle: 'Next',
                    onPressed: () {
                      if (isRestroSelected) {
                        Get.to(() => const RestroLogin());
                      } else if (isGrocerySelected) {
                        Get.to(() => const GroceryLogin());
                      } else if (isNgoSelected) {
                        Get.to(() => const NgoVolLogin());
                      } else if (isRuSelected) {
                        Get.to(() => const RuDeliveryLogin());
                      } else {
                        Get.snackbar(
                            'Error!', 'Please choose a user type to continue');
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
