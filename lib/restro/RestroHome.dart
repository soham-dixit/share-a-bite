import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestroHome extends StatefulWidget {
  const RestroHome({super.key});

  @override
  State<RestroHome> createState() => _RestroHomeState();
}

class _RestroHomeState extends State<RestroHome> {
  String restroName = '';
  String uid = '';

  Future<DocumentSnapshot> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    if (uid != null && uid.isNotEmpty) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(uid)
          .get();
      return snapshot;
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
            Size.fromHeight(MediaQuery.of(context).size.height * 0.120),
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
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: FutureBuilder<DocumentSnapshot>(
              future: getUserDetails(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                    // leading: IconButton(
                    //   onPressed: () {
                    //     Get.toNamed('/RestroMenu');
                    //   },
                    //   icon: const Icon(
                    //     Icons.menu,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    String name = snapshot.data!.get('name');
                    String phoneNumber = snapshot.data!.get('phone');

                    return AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $name',
                            style: const TextStyle(
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
                          Get.toNamed('/RestroMenu');
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
                          Get.toNamed('/menu');
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
        padding: const EdgeInsets.only(top: 30, bottom: 30),
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
                        // setState(() {});
                        Get.toNamed('/DistributeForm');
                      },
                      child: Container(
                        width: 300,
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
                                'assets/mis/distribute.svg',
                                height: 90,
                                width: 90,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Distribute Excess Food',
                                style: TextStyle(
                                  fontSize: 20,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 300,
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
                                height: 80,
                                width: 80,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Pending Requests',
                                style: TextStyle(
                                  fontSize: 20,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 300,
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
                                height: 15,
                              ),
                              const Text(
                                'Completed Requests',
                                style: TextStyle(
                                  fontSize: 20,
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
