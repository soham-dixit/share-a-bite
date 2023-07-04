import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:shared_preferences/shared_preferences.dart';

class PendingReq extends StatefulWidget {
  const PendingReq({Key? key}) : super(key: key);

  @override
  State<PendingReq> createState() => _PendingReqState();
}

class _PendingReqState extends State<PendingReq> {
  String? uid = '';
  List latitudes = [];
  List longitudes = [];
  List names = [];
  List emails = [];
  List phones = [];
  List Address = [];
  dynamic key_list = [];
  dynamic nearest_list = [];
  dynamic key_list_pending = [];

  getRestroLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');

    var collection = FirebaseFirestore.instance.collection('restaurants');
    var querySnapshots = await collection.get();
    for (var snapshot in querySnapshots.docs) {
      var documentID = snapshot.id; // <-- Document ID
      // var data = snapshot.data() as Map; // <-- Your data
      key_list.add(documentID);
    }
    // get latitute and longitude from key_list and store in latitudes and longitudes
    for (var i = 0; i < key_list.length; i++) {
      var document =
          FirebaseFirestore.instance.collection('restaurants').doc(key_list[i]);
      var snapshot = await document.get();

      if (snapshot.exists) {
        var documentID = snapshot.id; // <-- Document ID
        var data = snapshot.data() as Map<String, dynamic>; // <-- Your data
        var latitude = data['latitude'];
        var longitude = data['longitude'];
        // var name = data['name'];
        // var email = data['email'];
        // var phone = data['phone'];
        // var address = data['address'];

        // Process the latitude and longitude values as needed
        latitudes.add(latitude);
        longitudes.add(longitude);
        // names.add(name);
        // emails.add(email);
        // phones.add(phone);
        // Address.add(address);
      }
    }

    print(latitudes);
    print(longitudes);

    // calculate which restro is in 10km radius and store in list
    for (var i = 0; i < latitudes.length; i++) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocator.LocationAccuracy.high);
      double distanceInMeters = geolocator.Geolocator.distanceBetween(
          position.latitude, position.longitude, latitudes[i], longitudes[i]);
      print('distance in meters $distanceInMeters');
      if (distanceInMeters < 10000) {
        nearest_list.add(key_list[i]);
        print(nearest_list);
        print(nearest_list.length);
      } else {
        print('restro is not in 10km radius');
      }
      getNearestRestroDetails(nearest_list);
    }
    // getKeysFromListCollection(nearest_list);
  }

  getNearestRestroDetails(dynamic nearest_list) async {
    for (var i = 0; i < nearest_list.length; i++) {
      final docRef = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(nearest_list[i]);
      docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = data['name'];
          final email = data['email'];
          final phone = data['phone'];
          final address = data['address'];
          names.add(name);
          emails.add(email);
          phones.add(phone);
          Address.add(address);
          print(names);
          print(emails);
          print(phones);
          print(Address);
        },
        onError: (e) => print("Error getting document: $e"),
      );
    }
  }

  getKeysFromListCollection(dynamic nearest_list) async {
    // get keys from list collection
    for (var i = 0; i < nearest_list.length; i++) {
      var collection = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(nearest_list[i])
          .collection('distribution')
          .doc('pending');
    }
  }

  callMethods() async {
    getRestroLocation();
    // getReqDetails();
  }

  @override
  void initState() {
    super.initState();
    callMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        'assets/mis/back.svg',
                      ),
                    ),
                    SizedBox(
                      height: 33,
                    ),
                    const Text(
                      'Pending Requests',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    ReqCard(
                      restroName: 'Resto',
                      foodName: 'Pizza',
                      foodType: 'Veg',
                      shelfLife: 'timestamp',
                      status: 'Pending',
                      onPress: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
