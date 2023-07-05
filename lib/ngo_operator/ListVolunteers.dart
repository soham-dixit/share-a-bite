import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListVolunteers extends StatefulWidget {
  const ListVolunteers({super.key});

  @override
  State<ListVolunteers> createState() => _ListVolunteersState();
}

class _ListVolunteersState extends State<ListVolunteers> {
  String? uid = '';
  dynamic keys_list = [];
  int cout = 0;
  String? key;
  List<dynamic> data = [];
  var result;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.once();
    Map<dynamic, dynamic> databaseData = event.snapshot.value as Map;
    keys_list = databaseData['ngo'][uid]['volunteers'].keys.toList();

    data.clear();

    if (databaseData['ngo'] != null) {
      for (String key in keys_list) {
        dynamic volData = databaseData['ngo'][uid]['volunteers'][key];
        data.addAll(volData.values.toList());
      }
    }

    print(data.length);
    print(data);
    return data;
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
                      'Manage Volunteers',
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
                                          (snapshot.data.length / 4).floor(),
                                      itemBuilder: (context, i) {
                                        return VolunteerCard(
                                            name: snapshot.data[4 * i + 1],
                                            email: snapshot.data[4 * i + 2],
                                            phone: snapshot.data[4 * i + 0],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/AddVolunteer');
        },
        backgroundColor: Color(0xffff3333),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
