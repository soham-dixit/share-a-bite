import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DistributeForm extends StatefulWidget {
  const DistributeForm({super.key});

  @override
  State<DistributeForm> createState() => _DistributeFormState();
}

final TextEditingController _locationController = TextEditingController();
final TextEditingController _foodTypeController = TextEditingController();
final TextEditingController _foodNameController = TextEditingController();
final TextEditingController _quantityController = TextEditingController();
final TextEditingController _shelfLifeController = TextEditingController();
final TextEditingController _photoController = TextEditingController();

class _DistributeFormState extends State<DistributeForm> {
  final formKey = GlobalKey<FormState>();

  String? selectedValue;
  String? _currentAddress;
  Position? _currentPosition;
  String latitude = '';
  String longitude = '';

  final locationValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter your location'),
  ]);

  final foodTypeValidator = MultiValidator([
    RequiredValidator(errorText: 'Please select food type'),
  ]);

  final foodNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter food name'),
  ]);

  final quantityValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter quantity'),
  ]);

  final shelfLifeValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter shelf life'),
  ]);

  final List<String> foodTypes = [
    'Veg',
    'Non-veg',
  ];

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      latitude = _currentPosition!.latitude.toString();
      longitude = _currentPosition!.longitude.toString();
      // print('LATITUDE: $latitude');
      // print('LONGITUDE: $longitude');
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.name}, ${place.subLocality}, ${place.locality}';
        // print(_currentAddress);
        _locationController.text = _currentAddress!;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  DateTimePickerType lastPickerType = DateTimePickerType.Date;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<DateTimeSelection?> pickDateTime() async {
    if (lastPickerType == DateTimePickerType.Date) {
      DateTime? date = await pickDate();
      selectedDate = date;
      if (date == null) {
        // remove focus
        FocusScope.of(context).requestFocus(FocusNode());
        return null;
      }

      lastPickerType = DateTimePickerType.Time;
      TimeOfDay? time = await pickTime();
      selectedTime = time;
      if (time == null) {
        lastPickerType = DateTimePickerType.Date;
        FocusScope.of(context).requestFocus(FocusNode());
        return null;
      }

      lastPickerType = DateTimePickerType.Date;
      return DateTimeSelection(date: date, time: time);
    } else {
      lastPickerType = DateTimePickerType.Date;
      return null;
    }
  }

  Future<DateTime?> pickDate() {
    return showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> pickTime() {
    return showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
  }

  _uploadPhoto() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Photo'),
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

  File? image;
  bool isImageUploaded = false;
  String? uid;
  String? imageUrl;

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

  _submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      await uploadImage();
      Timestamp selectedTimestamp = Timestamp.fromDate(selectedDate!);
      DateTime dateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      Timestamp dateTimeTimestamp = Timestamp.fromDate(dateTime);
      String requestId = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(uid)
          .collection('distribution')
          .doc()
          .id;

      FirebaseFirestore.instance
          .collection('restaurants')
          .doc(uid)
          .collection('distribution')
          .doc('pending')
          .collection(requestId) // Use the generated document ID
          .doc('request')
          .set({
        'address': _locationController.text,
        'foodType': selectedValue.toString(),
        'foodName': _foodNameController.text,
        'quantity': _quantityController.text,
        'shelfLife': _shelfLifeController.text,
        'photo': imageUrl,
        'expiryTime': dateTimeTimestamp,
        'latitude': latitude,
        'longitude': longitude,
        'status': 'pending',
      });
    }
    navigateToHome();
  }

  navigateToHome() async {
    Get.back();
    Get.snackbar(
      'Success!',
      'Your request has been submitted successfully',
    );
  }

  uploadImage() async {
    if (image != null) {
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'images/restaurants/distribution/$uid/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask task = firebaseStorageRef.putFile(image!);

      // Wait for the upload task to complete and get the download URL
      await task.whenComplete(() {});

      // Get the download URL
      imageUrl = await firebaseStorageRef.getDownloadURL();
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
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
                        'Distribute Excess Food',
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _locationController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                          validator: locationValidator,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            label: Text('Location'),
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
                        GestureDetector(
                          onTap: () {
                            _getCurrentPosition();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.black45,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Detect my location',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF616161),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DropdownButtonFormField2(
                          decoration: InputDecoration(
                            //Add isDense true and zero Padding.
                            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                            isDense: true,
                            contentPadding: EdgeInsets.only(left: 0, right: 0),
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
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Food Type',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF616161),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding:
                              const EdgeInsets.only(left: 0, right: 15),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          items: foodTypes
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ))
                              .toList(),
                          // validator: foodTypeValidator,
                          onChanged: (value) {
                            //Do something when changing the item if you want.
                            selectedValue = value.toString();
                          },
                          onSaved: (value) {
                            selectedValue = value.toString();
                            controller:
                            _foodTypeController;
                          },
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        TextFormField(
                          controller: _foodNameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                          validator: foodNameValidator,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            label: Text('Food name'),
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
                          controller: _quantityController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                          validator: quantityValidator,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            label: Text('Quantity'),
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
                        FocusScope(
                          child: Focus(
                            onFocusChange: (hasFocus) async {
                              if (hasFocus) {
                                final dateTimeSelection = await pickDateTime();
                                if (dateTimeSelection != null) {
                                  final date = dateTimeSelection.date;
                                  final time = dateTimeSelection.time;

                                  if (date != null && time != null) {
                                    final dateTime = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );
                                    _shelfLifeController.text =
                                        DateFormat("dd-MM-yyyy, hh:mm a")
                                            .format(dateTime);
                                    // remove focus
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  }
                                }
                              }
                            },
                            child: TextFormField(
                              readOnly: true,
                              controller: _shelfLifeController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                              ),
                              validator: shelfLifeValidator,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                label: Text('Shelf life'),
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
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
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
                                      ? 'Image Uploaded'
                                      : 'Upload Photo',
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
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                  padding:
                      // calculate mobile screen height and divide it by 2
                      EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100,
                          bottom: 20),
                  child: MainButton(
                    initialTitle: 'Submit',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _submitForm();
                        print('Form is valid');
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

class DateTimeSelection {
  final DateTime? date;
  final TimeOfDay? time;

  DateTimeSelection({this.date, this.time});
}

enum DateTimePickerType {
  Date,
  Time,
}
