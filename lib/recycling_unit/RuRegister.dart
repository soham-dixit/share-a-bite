import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/login/RuOpLogin.dart';
import 'package:share_a_bite/recycling_unit//RuVerify.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';

class RuRegister extends StatefulWidget {
  const RuRegister({super.key});

  @override
  State<RuRegister> createState() => _RuRegisterState();
}

final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _contactController = TextEditingController();
final TextEditingController _licenseController = TextEditingController();
final TextEditingController _addressController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class _RuRegisterState extends State<RuRegister> {
  final formKey = GlobalKey<FormState>();
  bool already_exists = false;

  final emailValidator = MultiValidator([
    EmailValidator(errorText: 'Please enter a valid email ID'),
    RequiredValidator(errorText: 'Please enter an email ID')
  ]);

  final contactValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter a contact number'),
    PatternValidator(r'^(?=.{10,11}$)[6-9].*$',
        errorText: 'Please enter valid contact number')
  ]);

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter a business name'),
  ]);

  navigateToLogin() {
    Get.back();
  }

  check_if_already_exists() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.once();
    Map<dynamic, dynamic> databaseData = event.snapshot.value as Map;
    if (databaseData['recycling_units'] != null) {
      dynamic keys_list = databaseData['recycling_units'].keys.toList();
      for (int i = 0; i < keys_list.length; i++) {
        if (databaseData['recycling_units'][keys_list[i]]
                .containsValue(_contactController.text) ||
            databaseData['recycling_units'][keys_list[i]]
                .containsValue(_emailController.text)) {
          already_exists = true;
        }
      }
    }
    already_exists
        ? Get.snackbar('Error', 'Email or phone is already registered')
        : null;
  }

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
                'Register as Recycling unit',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              SvgPicture.asset(
                'assets/users/ru.svg',
                height: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Enter your information",
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
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                      validator: nameValidator,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        label: Text('Business Name'),
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
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      controller: _contactController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                      validator: contactValidator,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        label: Text('Contact Number'),
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
                      initialTitle: 'Next',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // inputs = [
                          //   _emailController.text,
                          //   _passwordController.text
                          // ];
                          check_if_already_exists().whenComplete(() {
                            already_exists
                                ? null
                                : Get.to(() => RuRegister2(
                                      name: _nameController.text.toString(),
                                      email: _emailController.text.toString(),
                                      contact:
                                          _contactController.text.toString(),
                                    ));
                          });
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
                          'Already registered?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: navigateToLogin,
                          child: const Text(
                            ' Login now',
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
            ],
          ),
        ),
      ),
    );
  }
}

class RuRegister2 extends StatefulWidget {
  final String name;
  final String email;
  final String contact;
  const RuRegister2(
      {Key? key,
      required this.name,
      required this.email,
      required this.contact})
      : super(key: key);

  @override
  _RuRegister2State createState() => _RuRegister2State();
}

class _RuRegister2State extends State<RuRegister2> {
  final formKey = GlobalKey<FormState>();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter a password'),
    MinLengthValidator(6, errorText: 'Minimum 6 characters'),
    PatternValidator(
      r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])',
      errorText: 'Letters, numbers, and at least one special character',
    ),
  ]);

  final licenseValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter a license number'),
    PatternValidator(r'^[a-zA-Z0-9]{8}$',
        errorText:
            'Must be 8 digits and a combination of alphabets and numbers')
  ]);

  final addressValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter a address'),
  ]);

  navigateToLogin() {
    Get.offAll(() => const RuOpLogin());
  }

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
                'Login as Recycling unit delivery partner',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              SvgPicture.asset(
                'assets/users/ru.svg',
                height: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Enter your information",
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
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _licenseController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                      validator: licenseValidator,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        label: Text('License Number'),
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
                      controller: _addressController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                      validator: addressValidator,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        label: Text('Address'),
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
                      obscureText: true,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
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
                      initialTitle: 'Verify',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // inputs = [
                          //   _emailController.text,
                          //   _passwordController.text
                          // ];
                          Get.to(() => RuVerify(
                                name: widget.name,
                                email: widget.email,
                                phone: widget.contact,
                                password: _passwordController.text.toString(),
                                address: _addressController.text.toString(),
                                license: _licenseController.text.toString(),
                              ));
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
                          'Already registered?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: navigateToLogin,
                          child: const Text(
                            ' Login now',
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
            ],
          ),
        ),
      ),
    );
  }
}
