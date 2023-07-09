import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';

class VolVerify extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String phone;
  const VolVerify(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      required this.phone});

  @override
  State<VolVerify> createState() => _VolVerifyState();
}

class _VolVerifyState extends State<VolVerify> {
  String code = "";

  sendCodeAgain() {
    Get.snackbar('Success!', 'OTP sent successfully');
  }

  verifyCodeNew(String code) async {
    if ("1234" == code) {
      Get.snackbar('Success!', 'OTP verified successfully');
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 130,
            ),
            SvgPicture.asset(
              'assets/mis/verify.svg',
              height: 62,
              width: 62,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Text(
                'Verify Mobile',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                'We sent OTP code on your mobile number',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(191, 0, 0, 0),
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            OtpTextField(
              numberOfFields: 4,
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              filled: true,
              fieldWidth: 44,
              focusedBorderColor: Colors.transparent,
              //disable border
              enabledBorderColor: Colors.transparent,
              keyboardType: TextInputType.number,
              //disable curcor
              cursorColor: Color.fromRGBO(255, 51, 51, 0.08),
              fillColor: Color.fromRGBO(255, 51, 51, 0.08),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              textStyle: const TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                // verifyCodeNew(verificationCode);
                code = verificationCode;
              }, // end onSubmit
            ),
            const SizedBox(
              height: 40,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Didn\'t receive the code? ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Color.fromARGB(191, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: sendCodeAgain,
                    child: const Text(
                      'Request again',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffff3333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Constants.getScreenHeight(context) * 0.3,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: MainButton(
                  initialTitle: 'Verify OTP',
                  onPressed: () async {
                    bool result = await verifyCodeNew(code);
                    if (result) {
                      Get.to(() => VolVerify2(
                            // send all the data to the next screen
                            name: widget.name,
                            email: widget.email,
                            phone: widget.phone,
                            password: widget.password,
                          ));
                    } else {
                      Get.snackbar(
                          "Error", "Please verify your mobile number!");
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}

class VolVerify2 extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String phone;

  const VolVerify2(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      required this.phone});

  @override
  State<VolVerify2> createState() => _VolVerify2State();
}

class _VolVerify2State extends State<VolVerify2> {
  String code = "";
  List keys_list = [];
  List vol_list = [];
  String? key;

  sendCodeAgain() {}

  verifyCodeNew(String code) async {
    if ("1234" == code) {
      Get.snackbar('Success!', 'OTP verified successfully');
      return true;
    } else {
      return false;
    }
  }

  registerVolunteer() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: widget.email, password: widget.password);

    // checkNgo();
    saveInfo();
  }

  // checkNgo() async {
  //   final databaseReference = FirebaseDatabase.instance.ref();
  //   DatabaseEvent event = await databaseReference.once();
  //   Map<dynamic, dynamic> databaseData = event.snapshot.value as Map;
  //   keys_list = databaseData['ngo'].keys.toList();
  //   print(keys_list);

  //   if (databaseData['ngo'] != null) {
  //     for (int i = 0; i < keys_list.length; i++) {
  //       key = keys_list[i];
  //       if (databaseData['ngo'][keys_list[i]]['volunteers'] != null) {
  //         vol_list.add(
  //             databaseData['ngo'][keys_list[i]]['volunteers'].keys.toList());
  //         print(vol_list);
  //         for (int j = 0; j < vol_list.length; j++) {
  //           if (vol_list[j] != null &&
  //               databaseData['ngo'][keys_list[0]]['volunteers'][vol_list[j]] !=
  //                   null) {
  //             if (databaseData['ngo'][keys_list[0]]['volunteers'][vol_list[j]]
  //                 .contains(widget.email)) {
  //               Get.snackbar('Error', 'Email already exists');
  //               return;
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  saveInfo() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    final uid = user.uid;
    databaseReference.child("volunteers").child(uid).set({
      'name': widget.name,
      'email': widget.email,
      'phone': widget.phone,
    }).whenComplete(() {
      Get.snackbar('Success', 'Registered Successfully');
      Get.offAllNamed('/NgoVolLogin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 130,
            ),
            SvgPicture.asset(
              'assets/mis/verify.svg',
              height: 62,
              width: 62,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Text(
                'Verify Email',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                'We sent OTP code on your email address',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(191, 0, 0, 0),
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            OtpTextField(
              numberOfFields: 4,
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              filled: true,
              fieldWidth: 44,
              focusedBorderColor: Colors.transparent,
              //disable border
              enabledBorderColor: Colors.transparent,
              keyboardType: TextInputType.number,
              //disable curcor
              cursorColor: Color.fromRGBO(255, 51, 51, 0.08),
              fillColor: Color.fromRGBO(255, 51, 51, 0.08),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              textStyle: const TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                // verifyCodeNew(verificationCode);
                code = verificationCode;
              }, // end onSubmit
            ),
            const SizedBox(
              height: 40,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Didn\'t receive the code? ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Color.fromARGB(191, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: sendCodeAgain,
                    child: const Text(
                      'Request again',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffff3333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Constants.getScreenHeight(context) * 0.3,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: MainButton(
                  initialTitle: 'Verify OTP',
                  onPressed: () async {
                    bool result = await verifyCodeNew(code);
                    if (result) {
                      registerVolunteer();
                      // checkNgo();
                    } else {
                      Get.snackbar(
                          "Error", "Please verify your email address!");
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}
