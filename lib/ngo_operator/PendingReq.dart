import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
  List keys_list = [];
  dynamic nearest_list = [];
  dynamic pending_list = [];
  String? key;
  int pendingCount = 0;
  List<dynamic> pendingListData = [];
  List data = [];
  var result;

  getRestroLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.once();
    Map<dynamic, dynamic> databaseData = event.snapshot.value as Map;
    keys_list = databaseData['restaurants'].keys.toList();

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

    print('latitudes $latitudes');
    print('longitudes $longitudes');

    for (var i = 0; i < latitudes.length; i++) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocator.LocationAccuracy.high);
      double distanceInMeters = geolocator.Geolocator.distanceBetween(
          position.latitude, position.longitude, latitudes[i], longitudes[i]);
      print('distance in meters $distanceInMeters');
      if (distanceInMeters < 10000) {
        nearest_list.add(keys_list[i]);
      } else {
        print('restro is not in 10km radius');
      }
    }

    for (var i = 0; i < nearest_list.length; i++) {
      if (databaseData['restaurants'][nearest_list[i]]['distribution']
              ['pending'] !=
          null) {
        pending_list = databaseData['restaurants'][nearest_list[i]]
                ['distribution']['pending']
            .keys
            .toList();
      }
    }

    print('nearest list $nearest_list');
    print('pending list $pending_list');
    pendingListData = [];

    if (databaseData['restaurants'] != null) {
      for (String key in nearest_list) {
        for (String pendingKey in pending_list) {
          dynamic pendingData = databaseData['restaurants'][key]['distribution']
              ['pending'][pendingKey];
          pendingListData.addAll(pendingData.values.toList());
        }
      }
    }

    print('pending list data $pendingListData');

    print(pendingListData.length);

    return pendingListData;
  }

  // getPendingList() async {
  //   final databaseReference = FirebaseDatabase.instance.ref();
  //   DatabaseEvent event = await databaseReference.once();
  //   Map<dynamic, dynamic> databaseData = event.snapshot.value as Map;
  //   // print(databaseData);

  //   pendingListData = [];

  //   if (databaseData['restaurants'] != null) {
  //     for (String key in nearest_list) {
  //       for (String pendingKey in pending_list) {
  //         dynamic pendingData = databaseData['restaurants'][key]['distribution']
  //             ['pending'][pendingKey];
  //         pendingListData.addAll(pendingData.values.toList());
  //       }
  //     }
  //   }

  //   return pendingListData;
  // }

  test() {
    print('card pressed');
  }

  // @override
  // void initState() {
  //   super.initState();
  //   result = getRestroLocation();
  // }

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
                    SingleChildScrollView(
                      child: Column(children: [
                        FutureBuilder(
                            future: getRestroLocation(),
                            builder: (context, AsyncSnapshot snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CupertinoActivityIndicator());
                                case ConnectionState.none:
                                  return Text('none');
                                case ConnectionState.active:
                                  return Text('active');
                                case ConnectionState.done:
                                  if (snapshot.data.length > 0) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          (snapshot.data.length / 10).floor(),
                                      itemBuilder: (context, i) {
                                        return ReqCard(
                                            restroName:
                                                snapshot.data[10 * i + 6],
                                            foodName: snapshot.data[10 * i + 0],
                                            foodType: snapshot.data[10 * i + 3],
                                            shelfLife:
                                                snapshot.data[10 * i + 7],
                                            status: snapshot.data[10 * i + 9],
                                            onPress: () {});
                                      },
                                    );
                                  } else {
                                    return Text('No pending requests');
                                  }
                              }
                            })
                      ]),
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
