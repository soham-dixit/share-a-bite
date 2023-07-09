import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/ngo_volunteer/AcceptedReqDetails.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptedReqVol extends StatefulWidget {
  const AcceptedReqVol({super.key});

  @override
  State<AcceptedReqVol> createState() => _AcceptedReqVolState();
}

class _AcceptedReqVolState extends State<AcceptedReqVol> {
  String? uid = '';
  dynamic keys_list = [];
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
    Map<dynamic, dynamic> databaseData = event.snapshot.value as Map;
    keys_list = databaseData['volunteers'][uid]['distribution']['accepted']
        .keys
        .toList();
    // print(keys_list);
    pendingListData.clear();

    if (databaseData['volunteers'] != null) {
      for (String key in keys_list) {
        dynamic pendingData =
            databaseData['volunteers'][uid]['distribution']['accepted'][key];
        pendingListData.addAll(pendingData.values.toList());
      }
    }
    // print('pending list data $pendingListData');

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
                                                snapshot.data[10 * i + 8],
                                            foodName: snapshot.data[10 * i + 7],
                                            foodType: snapshot.data[10 * i + 5],
                                            shelfLife:
                                                snapshot.data[10 * i + 2],
                                            status: snapshot.data[10 * i + 3],
                                            onPress: () {
                                              Get.to(() => AcceptedReqDetails(
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
