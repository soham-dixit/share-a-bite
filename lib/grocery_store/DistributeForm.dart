import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
/*import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';*/
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
import 'package:tflite/tflite.dart';

class DistributeForm extends StatefulWidget {
  const DistributeForm({super.key});

  @override
  State<DistributeForm> createState() => _DistributeFormState();
}

final TextEditingController _locationController = TextEditingController();
final TextEditingController _foodNameController = TextEditingController();
final TextEditingController _quantityController = TextEditingController();
final TextEditingController _shelfLifeController = TextEditingController();
final TextEditingController _photoController = TextEditingController();

class _DistributeFormState extends State<DistributeForm> {
  final formKey = GlobalKey<FormState>();
  List predictions = [];
  bool _loading = true;
  
  String? _currentAddress;
  Position? _currentPosition;
  String latitude = '';
  String longitude = '';
  var newChildKey = '';
  String? name = '';
  bool isFresh = true;

  final locationValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter your location'),
  ]);

  final foodNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter product name'),
  ]);

  final quantityValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter quantity'),
  ]);

  final shelfLifeValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter shelf life'),
  ]);

  Future<void> _getCurrentPosition() async {
    final user = FirebaseAuth.instance.currentUser;
    name = user!.displayName;
    print('name$name');

    // final hasPermission = await _handleLocationPermission();
    // if (!hasPermission) return;
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
      detectImage(imageTemp);
      uploadImage();
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
      detectImage(imageTemp);
      uploadImage();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  detectImage(File img) async {
    var prediction = await Tflite.runModelOnImage(
        path: img.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _loading = false;
      predictions = prediction!;
    });
    print('prediction: $predictions');
    if (predictions[0]['label'].contains('rotten')) {
      isFresh = false;
      // clear predictions
      predictions = [];
    } else {
      isFresh = true;
      predictions = [];
    }
    return;
  }

  _submitForm() async {
    if (formKey.currentState!.validate()) {
      print('Form is valid');
      // formKey.currentState!.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('uid');
      Timestamp selectedTimestamp = Timestamp.fromDate(selectedDate!);
      DateTime dateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      Timestamp dateTimeTimestamp = Timestamp.fromDate(dateTime);

      final intLatitude = _currentPosition!.latitude.toDouble();
      final intLongitude = _currentPosition!.longitude.toDouble();

      final databaseReference = FirebaseDatabase.instance.ref();
      final newChildRef = databaseReference
          .child("grocery")
          .child(uid!)
          .child('distribution')
          .child('pending')
          .push();

      newChildKey = newChildRef.key!;
      await uploadImage();

      newChildRef.set({
        'address': _locationController.text,
        'foodName': _foodNameController.text,
        'quantity': _quantityController.text,
        'shelfLife': _shelfLifeController.text,
        'photo': imageUrl,
        'latitude': intLatitude,
        'longitude': intLongitude,
        'status': 'pending',
        'groceryName': name,
      });

      print('New child key: $newChildKey');
    }

    navigateToHome();
  }

  navigateToHome() {
    // clear all the text fields
    _locationController.clear();
    _foodNameController.clear();
    _quantityController.clear();
    _shelfLifeController.clear();

    Get.back();
    Get.snackbar(
      'Success!',
      'Your request has been submitted successfully',
    );
  }

  uploadImage() async {
    if (image != null) {
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'images/grocery/distribution/pending/$newChildKey/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask task = firebaseStorageRef.putFile(image!);

      // Wait for the upload task to complete and get the download URL
      await task.whenComplete(() {});

      // Get the download URL
      imageUrl = await firebaseStorageRef.getDownloadURL();
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model/model.tflite',
      labels: 'assets/model/labels.txt',
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    loadModel();
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
                        'Donate Products',
                        style: TextStyle(
                          fontSize: 26,
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
                            label: Text('Product name'),
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
                                        DateFormat("hh:mm a, dd-MM-yyyy")
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
                                      ? 'Photo uploaded'
                                      : 'Upload photo',
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
                      top: MediaQuery.of(context).size.height / 30,
                      bottom: 20),
                  child: MainButton(
                    initialTitle: 'Submit',
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          isFresh == true) {
                        _submitForm();
                        print('Form is valid');
                      } else {
                        Get.snackbar('Error', 'Please donate eatable food');
                      }
                    },
                  ))
                  : Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 20),
                  child: MainButton(
                    initialTitle: 'Submit',
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          isImageUploaded &&
                          isFresh == true) {
                        _submitForm();
                        print('Form is valid');
                      } else {
                        Get.snackbar('Error', 'Please upload photo');
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
