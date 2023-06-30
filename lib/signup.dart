import 'package:flutter/material.dart';
import 'package:share_a_bite/validate.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _isEmailValid = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: content(),
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(40, 40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Icon(
                Icons.person_add,
                size: 30,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Signup",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
              ),
              inputForm("Name", _nameController),
              SizedBox(
                height: 20,
              ),
              inputForm("Email", _emailController),
              SizedBox(
                height: 20,
              ),
              inputForm("Contact Number", _contactNumberController),
              SizedBox(
                height: 20,
              ),
              inputForm("Password", _passwordController),
              SizedBox(
                height: 20,
              ),
              inputForm("Confirm Password", _confirmPasswordController),
              SizedBox(
                height: 30,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget inputForm(String title, TextEditingController controller) {
    bool isPassword = title == "Password" || title == "Confirm Password";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: title == "Email"
                ? Border.all(
              width: 0.5,
              color: controller.text.isEmpty
                  ? Colors.grey
                  : _isEmailValid
                  ? Colors.green
                  : Colors.red,
            )
                : Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: TextStyle(fontSize: 14),
                    obscureText: isPassword && !_isPasswordVisible,
                    onChanged: (value) {
                      if (title == "Email") {
                        if (value.isEmpty) {
                          setState(() {
                            _isEmailValid = false;
                          });
                        } else {
                          final isValid = validateEmailAddress(value);
                          setState(() {
                            _isEmailValid = isValid;
                          });
                        }
                      }
                    },
                  ),
                ),
                if (isPassword)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
