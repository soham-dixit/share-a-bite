import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/login/GroceryLogin.dart';
import 'package:share_a_bite/grocery_store/GroceryVerify.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';

class GroceryRegister extends StatefulWidget {
  const GroceryRegister({super.key});

  @override
  State<GroceryRegister> createState() => _GroceryRegisterState();
}

final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _contactController = TextEditingController();
final TextEditingController _licenseController = TextEditingController();
final TextEditingController _addressController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class _GroceryRegisterState extends State<GroceryRegister> {
  final formKey = GlobalKey<FormState>();

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
                'Register as Grocery store',
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
                          print(_nameController.text.toString());
                          print(_emailController.text.toString());
                          print(_contactController.text.toString());
                          Get.to(() => GroceryRegister2(
                            name: _nameController.text.toString(),
                            email: _emailController.text.toString(),
                            contact: _contactController.text.toString(),
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

class GroceryRegister2 extends StatefulWidget {
  final String name;
  final String email;
  final String contact;
  const GroceryRegister2(
      {Key? key,
        required this.name,
        required this.email,
        required this.contact})
      : super(key: key);

  @override
  _GroceryRegister2State createState() => _GroceryRegister2State();
}

class _GroceryRegister2State extends State<GroceryRegister2> {
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
    Get.offAll(() => const GroceryLogin());
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
                'Register as Grocery store',
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
                      keyboardType: TextInputType.text,
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
                          Get.to(() => GroceryVerify(
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
