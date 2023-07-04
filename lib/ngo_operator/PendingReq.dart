import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
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
  dynamic key_list = [];
  dynamic nearest_list = [];
  String? key;

  getRestroLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.once();
    Map<dynamic, dynamic> databaseData = event.snapshot.value as Map;
    dynamic keys_list = databaseData['restaurants'].keys.toList();

    if (databaseData['restaurants'] != null) {
      for (int i = 0; i < keys_list.length; i++) {
        key = keys_list[i];
        if (databaseData['restaurants'][keys_list[i]]['latitude'] != null) {
          latitudes.add(databaseData['restaurants'][keys_list[i]]['latitude']);
        }
        if (databaseData['restaurants'][keys_list[i]]['longitude'] != null) {
          longitudes
              .add(databaseData['restaurants'][keys_list[i]]['longitude']);
        }
      }
    }

    // calculate which restro is in 10km radius and store in list
    for (var i = 0; i < latitudes.length; i++) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocator.LocationAccuracy.high);
      double distanceInMeters = geolocator.Geolocator.distanceBetween(
          position.latitude, position.longitude, latitudes[i], longitudes[i]);
      print('distance in meters $distanceInMeters');
      if (distanceInMeters < 10000) {
        nearest_list.add(keys_list[i]);
        print(nearest_list);
        print(nearest_list.length);
      } else {
        print('restro is not in 10km radius');
      }
    }
  }

  callMethods() async {
    getRestroLocation();
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
