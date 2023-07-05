import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVolunteer extends StatefulWidget {
  const AddVolunteer({super.key});

  @override
  State<AddVolunteer> createState() => _AddVolunteerState();
}

final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();

class _AddVolunteerState extends State<AddVolunteer> {
  final formKey = GlobalKey<FormState>();
  bool isImageUploaded = false;
  File? image;
  String? uid;
  String? imageUrl;
  var newChildKey = '';

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter your fullname'),
  ]);

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter your email'),
    EmailValidator(errorText: 'Please enter a valid email address'),
  ]);

  final phoneValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter a contact number'),
    PatternValidator(r'^(?=.{10,11}$)[6-9].*$',
        errorText: 'Please enter valid contact number')
  ]);

  _submitForm() async {
    if (formKey.currentState!.validate()) {
      print('Form is valid');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      await uploadImage();
      final databaseReference = FirebaseDatabase.instance.ref();
      final newChildRef =
          databaseReference.child("ngo").child(uid!).child('volunteers').push();

      newChildKey = newChildRef.key!;
      await uploadImage();
      newChildRef.set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'photoid': imageUrl,
      });
    }
    navigateBack();
  }

  navigateBack() {
    Get.back();
    // clear all text fields
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    Get.snackbar('Success!', 'Volunteer has been added successfully');
  }

  _uploadPhoto() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Photo ID'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    _openGallery();
                  },
                ),
                Padding(padding: EdgeInsets.all(8)),
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () {
                    _openCamera();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _openGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      isImageUploaded = true;
      // uploadImage();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future _openCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      isImageUploaded = true;
      // uploadImage();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  uploadImage() async {
    if (image != null) {
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'images/ngo/$uid/volunteers//${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask task = firebaseStorageRef.putFile(image!);

      // Wait for the upload task to complete and get the download URL
      await task.whenComplete(() {});

      // Get the download URL
      imageUrl = await firebaseStorageRef.getDownloadURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 40,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: SvgPicture.asset(
                          'assets/mis/back.svg',
                          height: 48,
                          width: 48,
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: const [
                      Text(
                        'Add new volunteer',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: Color(0xFF4F200D),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                          validator: nameValidator,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            label: Text('Full name'),
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
                          controller: _phoneController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                          validator: phoneValidator,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            label: Text('Phone no'),
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
                        GestureDetector(
                          onTap: () {
                            _uploadPhoto();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_alt_sharp,
                                  size: 30,
                                  color: Colors.black45,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  isImageUploaded
                                      ? 'Photo ID uploaded'
                                      : 'Upload Photo ID',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Color(0xFF616161),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // preview image in box
                        isImageUploaded
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 180,
                                width: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(
                                        0xffff3333), // Set the color of the border
                                    width: 2, // Set the width of the border
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              isImageUploaded
                  ? Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 30),
                      child: MainButton(
                        initialTitle: 'Add',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _submitForm();
                            print('Form is valid');
                          }
                        },
                      ))
                  : Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4),
                      child: MainButton(
                        initialTitle: 'Add',
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              isImageUploaded) {
                            _submitForm();
                            print('Form is valid');
                          } else {
                            Get.snackbar('Error', 'Please upload photo ID');
                          }
                        },
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
