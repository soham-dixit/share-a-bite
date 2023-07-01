import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';

class RestroVerify extends StatefulWidget {
  const RestroVerify({super.key});

  @override
  State<RestroVerify> createState() => _RestroVerifyState();
}

class _RestroVerifyState extends State<RestroVerify> {
  String code = "";

  sendCodeAgain() {}

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
                    'Didn\'t received the code? ',
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
                      Get.to(() => const RestroVerify2());
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

class RestroVerify2 extends StatefulWidget {
  const RestroVerify2({super.key});

  @override
  State<RestroVerify2> createState() => _RestroVerify2State();
}

class _RestroVerify2State extends State<RestroVerify2> {
  String code = "";

  sendCodeAgain() {}

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
                    'Didn\'t received the code? ',
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
