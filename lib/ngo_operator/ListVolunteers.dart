import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ListVolunteers extends StatefulWidget {
  const ListVolunteers({super.key});

  @override
  State<ListVolunteers> createState() => _ListVolunteersState();
}

class _ListVolunteersState extends State<ListVolunteers> {
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
                    // SingleChildScrollView(
                    //   child: Column(children: [
                    //     FutureBuilder(
                    //         future: getData(),
                    //         builder: (context, AsyncSnapshot snapshot) {
                    //           switch (snapshot.connectionState) {
                    //             case ConnectionState.waiting:
                    //               return Center(
                    //                   child: CupertinoActivityIndicator());
                    //             case ConnectionState.none:
                    //               return Text('none');
                    //             case ConnectionState.active:
                    //               return Text('active');
                    //             case ConnectionState.done:
                    //               if (snapshot.data.length > 0) {
                    //                 return ListView.builder(
                    //                   shrinkWrap: true,
                    //                   physics: BouncingScrollPhysics(),
                    //                   scrollDirection: Axis.vertical,
                    //                   itemCount:
                    //                       (snapshot.data.length / 10).floor(),
                    //                   itemBuilder: (context, i) {
                    //                     return ReqCard(
                    //                         restroName:
                    //                             snapshot.data[10 * i + 8],
                    //                         foodName: snapshot.data[10 * i + 7],
                    //                         foodType: snapshot.data[10 * i + 5],
                    //                         shelfLife:
                    //                             snapshot.data[10 * i + 2],
                    //                         status: snapshot.data[10 * i + 3],
                    //                         onPress: () {});
                    //                   },
                    //                 );
                    //               } else {
                    //                 return Text('No pending requests');
                    //               }
                    //           }
                    //         })
                    //   ]),
                    // ),
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
