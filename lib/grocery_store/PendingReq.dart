import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/grocery_store/PendingReqDetails.dart';
import 'package:share_a_bite/restro/PendingReqDetails.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingReqGrocery extends StatefulWidget {
  const PendingReqGrocery({super.key});

  @override
  State<PendingReqGrocery> createState() => _PendingReqGroceryState();
}

class _PendingReqGroceryState extends State<PendingReqGrocery> {
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

    if (databaseData['grocery'] != null &&
        databaseData['grocery'][uid]['distribution'] != null &&
        databaseData['grocery'][uid]['distribution']['pending'] != null) {
      keys_list =
          databaseData['grocery'][uid]['distribution']['pending'].keys.toList();

      print(keys_list);
    }

    if (databaseData['grocery'] != null &&
        databaseData['grocery'][uid]['distribution'] != null &&
        databaseData['grocery'][uid]['distribution']['accepted'] != null) {
      keys_list = databaseData['grocery'][uid]['distribution']['accepted']
          .keys
          .toList();
    }

    // print(keys_list[0]);

    List<dynamic> pendingListData = [];

    for (String key in keys_list) {
      if (databaseData['grocery'][uid]['distribution']['pending'] != null) {
        dynamic pendingData =
            databaseData['grocery'][uid]['distribution']['pending'][key];
        if (pendingData != null) {
          pendingListData.addAll(pendingData.values.toList());
        }
      }
    }

    for (String key in keys_list) {
      if (databaseData['grocery'][uid]['distribution']['accepted'] != null) {
        dynamic acceptedData =
            databaseData['grocery'][uid]['distribution']['accepted'][key];
        if (acceptedData != null) {
          pendingListData.addAll(acceptedData.values.toList());
        }
      }
    }

    // print(pendingListData.length);

    print(pendingListData);

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
                                          (snapshot.data.length / 9).floor(),
                                      itemBuilder: (context, i) {
                                        return ReqCard(
                                            restroName:
                                                snapshot.data[9 * i + 6],
                                            foodName: snapshot.data[9 * i + 1],
                                            foodType: 'Expired',
                                            shelfLife: snapshot.data[9 * i + 0],
                                            status: snapshot.data[9 * i + 8],
                                            onPress: () {
                                              Get.to(() =>
                                                  PendingReqDetailsGrocery(
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
