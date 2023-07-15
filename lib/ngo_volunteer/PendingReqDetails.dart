import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_a_bite/widgets/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingReqDetailsVol extends StatefulWidget {
  final String id;
  const PendingReqDetailsVol({Key? key, required this.id}) : super(key: key);

  @override
  State<PendingReqDetailsVol> createState() => _PendingReqDetailsVolState();
}

class _PendingReqDetailsVolState extends State<PendingReqDetailsVol> {
  List<dynamic> keys_list = [];
  String? key;
  String restroKey = '';
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> data = {};

  getNode() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.once();
    Map<dynamic, dynamic> databaseData = event.snapshot.value as Map;
    keys_list = databaseData['restaurants'].keys.toList();

    print(keys_list);
    print(keys_list.length);

    if (databaseData['restaurants'] != null) {
      for (String token in keys_list) {
        bool hasPendingNode = await checkNode(token);
        if (hasPendingNode) {
          restroKey = token;
          getDetails(restroKey);
        } else {
          print('no data');
        }
      }
    }
  }

  getDetails(String key) async {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.once();
    Map<dynamic, dynamic> databaseData =
        event.snapshot.value as Map<dynamic, dynamic>;

    if (databaseData['restaurants'][key]['distribution']['pending'] != null) {
      dynamic pendingData = databaseData['restaurants'][key]['distribution']
          ['pending'][widget.id];
      if (pendingData is Map<dynamic, dynamic>) {
        setState(() {
          data = Map<String, dynamic>.from(pendingData);
          print(data);
        });
      }
    }
  }

  _accept() async {
    // accept request and add to accepted node in database
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid')!;
    final databaseReference = FirebaseDatabase.instance.ref();
    data['status'] = 'accepted';
    await databaseReference
        .child('restaurants')
        .child(restroKey)
        .child('distribution')
        .child('accepted')
        .child(widget.id)
        .set(data);
    // delete from pending node
    await databaseReference
        .child('restaurants')
        .child(restroKey)
        .child('distribution')
        .child('pending')
        .child(widget.id)
        .remove();
    await databaseReference
        .child('volunteers')
        .child(uid)
        .child('distribution')
        .child('accepted')
        .child(widget.id)
        .set(data);

    Get.back();
  }

  Future<bool> checkNode(String token) async {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference
        .child('restaurants')
        .child(token)
        .child('distribution')
        .child('pending')
        .once();
    return event.snapshot.value != null;
  }

  @override
  void initState() {
    super.initState();
    getNode();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 40,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                  SizedBox(height: 30),
                  Row(
                    children: const [
                      Text(
                        'Request Details',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: Color(0xFF4F200D),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Builder(builder: (context) {
                    if (data.isNotEmpty) {
                      return Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: false,
                                initialValue: data['restroName'] as String?,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Restaurant Name',
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: false,
                                initialValue: data['address'] as String?,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Location',
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: false,
                                initialValue: data['foodType'] as String?,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Food Type',
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: false,
                                initialValue: data['foodName'] as String?,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Food Name',
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: false,
                                initialValue: data['quantity'] as String?,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Quantity',
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: false,
                                initialValue: data['shelfLife'] as String?,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Shelf Life',
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              // show image
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 180,
                                width: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(
                                        0xffff3333), // Set the color of the border
                                    width: 2, // Set the width of the border
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(data['photo'] as String),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          30),
                                  child: MainButton(
                                    initialTitle: 'Accept',
                                    onPressed: () {
                                      _accept();
                                    },
                                  )),
                              SizedBox(
                                height: 22,
                              ),
                            ],
                          ));
                    } else {
                      return SizedBox();
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
