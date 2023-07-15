import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/ngo_operator/CompletedReq.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NgoHome extends StatefulWidget {
  const NgoHome({super.key});

  @override
  State<NgoHome> createState() => _NgoHomeState();
}

class _NgoHomeState extends State<NgoHome> {
  String ngoName = '';
  String uid = '';

  Future<DataSnapshot> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    if (uid != null && uid.isNotEmpty) {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

      // Retrieve the snapshot of the realtime database using uid
      DatabaseEvent snapshot = await databaseRef.child('ngo').child(uid).once();

      return snapshot.snapshot;
    } else {
      throw Exception('Invalid UID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.080),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffff3333),
                Color.fromARGB(255, 255, 162, 86),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: // 0.0
                    MediaQuery.of(context).size.height * 0.010),
            child: FutureBuilder<DataSnapshot>(
              future: getUserDetails(),
              builder:
                  (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Hi, Error',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    leading: IconButton(
                      onPressed: () {
                        Get.toNamed('/NgoOpMenu');
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    dynamic data = snapshot.data!.value;
                    String name = data['name'];
                    String phoneNumber = data['phone'];

                    return AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'NGO Operator',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Get.toNamed('/NgoOpMenu');
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      actions: const [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Image(
                              image: AssetImage('assets/logo/dbs.png'),
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hi, Data not found',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Get.toNamed('/NgoOpMenu');
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 0, bottom: 30),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Constants.getScreenHeight(context) * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFFF3333),
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/mis/ongoing.svg',
                                height: 80,
                                width: 80,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Ongoing Requests',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/NgoPendingReq');
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFFF3333),
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/mis/pending.svg',
                                height: 70,
                                width: 70,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Pending Requests',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // setState(() {});
                        Get.to(() => const CompletedReqOp());
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFFF3333),
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/mis/completed.svg',
                                height: 70,
                                width: 70,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Completed\n  Requests',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/ListVolunteers');
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFFF3333),
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/mis/manage.svg',
                                height: 80,
                                width: 80,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Manage Volunteers',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
