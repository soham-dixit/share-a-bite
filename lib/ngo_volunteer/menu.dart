import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolMenu extends StatefulWidget {
  const VolMenu({super.key});

  @override
  State<VolMenu> createState() => _VolMenuState();
}

class _VolMenuState extends State<VolMenu> {
  Future<DataSnapshot> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    if (uid != null && uid.isNotEmpty) {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

      // Retrieve the snapshot of the realtime database using uid
      DatabaseEvent snapshot =
          await databaseRef.child('volunteers').child(uid).once();

      return snapshot.snapshot;
    } else {
      throw Exception('Invalid UID');
    }
  }

  _logout(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        });
    Future.delayed(Duration(seconds: 1), () async {
      print(FirebaseAuth.instance.currentUser!.uid);
      await FirebaseAuth.instance.signOut();
      await SharedPreferences.getInstance().then((prefs) {
        prefs.remove('uid');
      });
      Get.offAllNamed('/MainLogin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: // calculate screen padding
              EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 40,
            left: 20,
            right: 20,
          ),
          child: Column(
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
              SizedBox(
                height: 28,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<DataSnapshot>(
                        future: getUserDetails(),
                        initialData: null,
                        builder: (BuildContext context,
                            AsyncSnapshot<DataSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.data == null) {
                            // Display a loading indicator while waiting for data
                            return const CupertinoActivityIndicator();
                          } else if (snapshot.hasError) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Error',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                Text(
                                  'Error',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: Color.fromRGBO(20, 20, 20, 0.6),
                                  ),
                                ),
                                Text(
                                  // email.toString(),
                                  'Error',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: Color.fromRGBO(20, 20, 20, 0.6),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            if (snapshot.hasData && snapshot.data!.exists) {
                              dynamic data = snapshot.data!.value;
                              String name = data['name'];
                              String phoneNumber = data['phone'];
                              String email = data['email'];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  Text(
                                    phoneNumber.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(20, 20, 20, 0.6),
                                    ),
                                  ),
                                  Text(
                                    email.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(20, 20, 20, 0.6),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Error',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  Text(
                                    'Error',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(20, 20, 20, 0.6),
                                    ),
                                  ),
                                  Text(
                                    'Error',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(20, 20, 20, 0.6),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                        }),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color.fromRGBO(20, 20, 20, 0.6),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color.fromRGBO(20, 20, 20, 0.6),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: const [
                  Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  // Get.toNamed('/DistributeForm');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Ongoing requests',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color.fromRGBO(20, 20, 20, 0.6),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color.fromRGBO(20, 20, 20, 0.6),
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Pending requests',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color.fromRGBO(20, 20, 20, 0.6),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color.fromRGBO(20, 20, 20, 0.6),
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Completed requests',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color.fromRGBO(20, 20, 20, 0.6),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color.fromRGBO(20, 20, 20, 0.6),
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Are you sure you want to log out?",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _logout(context);
                            },
                            child: const Text('Log out'),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: const Color(0xffff3333),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color.fromRGBO(20, 20, 20, 0.6),
                    )
                  ],
                ),
              ),
              Divider(
                color: Color.fromRGBO(20, 20, 20, 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
