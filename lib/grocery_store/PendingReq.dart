import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/restro/PendingReqDetails.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroceryPendingReq extends StatefulWidget {
  const GroceryPendingReq({super.key});

  @override
  State<GroceryPendingReq> createState() => _GroceryPendingReqState();
}

class _GroceryPendingReqState extends State<GroceryPendingReq> {
  String? uid = '';
  List keys_list = [];
  dynamic pending_list = [];
  int pendingCount = 0;
  String? key;
  List<dynamic> pendingListData = [];
  List data = [];
  var result;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.once();

    if (event.snapshot.value == null) {
      // Handle the case where no data is available
      print("No data available");
      return []; // Return an empty list or handle the error accordingly
    }

    Map<dynamic, dynamic> databaseData = event.snapshot.value as Map;
    // List<dynamic> keys_list = [];

    if (databaseData['restaurants'] != null &&
        databaseData['restaurants'][uid]['distribution'] != null &&
        databaseData['restaurants'][uid]['distribution']['pending'] != null) {
      keys_list = databaseData['restaurants'][uid]['distribution']['pending']
          .keys
          .toList();
    }

    if (databaseData['restaurants'] != null &&
        databaseData['restaurants'][uid]['distribution'] != null &&
        databaseData['restaurants'][uid]['distribution']['accepted'] != null) {
      keys_list = databaseData['restaurants'][uid]['distribution']['accepted']
          .keys
          .toList();
    }

    // print(keys_list[0]);

    List<dynamic> pendingListData = [];

    for (String key in keys_list) {
      if (databaseData['restaurants'][uid]['distribution']['pending'] != null) {
        dynamic pendingData =
        databaseData['restaurants'][uid]['distribution']['pending'][key];
        if (pendingData != null) {
          pendingListData.addAll(pendingData.values.toList());
        }
      }
    }

    for (String key in keys_list) {
      if (databaseData['restaurants'][uid]['distribution']['accepted'] !=
          null) {
        dynamic acceptedData =
        databaseData['restaurants'][uid]['distribution']['accepted'][key];
        if (acceptedData != null) {
          pendingListData.addAll(acceptedData.values.toList());
        }
      }
    }

    print(pendingListData.length);

    return pendingListData;
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
                    SingleChildScrollView(
                      child: Column(children: [
                        FutureBuilder(
                            future: getData(),
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
                                            onPress: () {
                                              Get.to(() =>
                                                  PendingReqDetailsRestro(
                                                      id: keys_list[i]));
                                            });
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
