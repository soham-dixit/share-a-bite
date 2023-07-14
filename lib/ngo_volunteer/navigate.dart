import 'dart:async';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:share_a_bite/services/network_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavVol extends StatefulWidget {
  String lat;
  String long;
  NavVol({Key? key, required this.lat, required this.long}) : super(key: key);

  @override
  State<NavVol> createState() => _NavVolState();
}

class _NavVolState extends State<NavVol> {
  final Completer<GoogleMapController> mapController = Completer();
  List<LatLng> polyPoints = [];
  final Set<Polyline> polyLines = {};
  final Set<Marker> markers = {};
  var duration, distance;
  Location currentLocation = Location();
  var location;
  var data;

  double vol_lat = 0.0;
  double vol_lng = 0.0;

  getData() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.once();
    Map<dynamic, dynamic> databaseData = event.snapshot.value as Map;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    final uid = user.uid;
    if (databaseData['volunteers'] != null) {
      vol_lat = databaseData['volunteers'][uid]['latitude'];
      vol_lng = databaseData['volunteers'][uid]['longitude'];
      // print("vol_lat $vol_lat");
      // print("vol_lng $vol_lng");
    }
  }

  getCurrentLocation() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    final uid = user.uid;
    location = await currentLocation.getLocation();

    GoogleMapController gmc = await mapController.future;

    currentLocation.onLocationChanged.listen((newLoc) {
      location = newLoc;
      gmc.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 17,
            target: LatLng(location.latitude, location.longitude),
          ),
        ),
      );
      databaseReference.child('volunteers').child(uid).update(
          {'latitude': location.latitude, 'longitude': location.longitude});
    });
  }

  addMarker() {
    double long = double.parse(widget.long);
    print('called');
    setState(() {
      markers.addAll([
        Marker(
          infoWindow: InfoWindow(title: 'Destination'),
          markerId: MarkerId('User'),
          position: LatLng(vol_lat, vol_lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () async {},
        ),
        // Marker(
        //   infoWindow: InfoWindow(title: 'Live Location'),
        //   markerId: MarkerId('live'),
        //   position: LatLng(
        //     location.latitude,
        //     location.longitude,
        //   ),
        //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        //   onTap: () async {},
        // ),
      ]);
    });
  }

  void getJsonData() async {
    double lat = double.parse(widget.lat);
    double long = double.parse(widget.long);
    NetworkHelper network = NetworkHelper(
      startLat: vol_lat,
      startLng: vol_lng,
      endLat: lat,
      endLng: long,
    );

    try {
      data = await network.getData();
      print('data ${data}');
      duration =
          (data['features'][0]['properties']['summary']['duration']) / 60;
      distance =
          (data['features'][0]['properties']['summary']['distance']) / 1000;
      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      setPolyLines();
    } catch (e) {
      print(e);
    }
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.lightBlue,
      width: 5,
      points: polyPoints,
    );
    polyLines.add(polyline);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().whenComplete(() {
      getCurrentLocation().whenComplete(() {
        addMarker();
      });
      getJsonData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(19.0760, 72.8777),
              zoom: 11.5,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
            },
            polylines: polyLines,
            markers: markers,
            // Marker(
            //   infoWindow: InfoWindow(title: 'Your location'),
            //   markerId: MarkerId('Operator'),
            //   position: LatLng(op_lat, op_lng),
            //   icon: BitmapDescriptor.defaultMarkerWithHue(
            //       BitmapDescriptor.hueGreen),
            //   onTap: () async {},
            // ),
            // Marker(
            //   infoWindow: InfoWindow(title: 'Destination'),
            //   markerId: MarkerId('User'),
            //   position: LatLng(u_lat, u_lng),
            //   icon: BitmapDescriptor.defaultMarkerWithHue(
            //       BitmapDescriptor.hueRed),
            //   onTap: () async {},
            // )
          ),
          if (duration != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.9,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFF23F44),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 50.0,
                    )
                  ],
                ),
                child: Text(
                  "${distance.toStringAsFixed(2)} KM, ${duration.toStringAsFixed(2)} Mins",
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontFamily: 'Poppins'),
                ),
              ),
            )
        ],
      ),
    );
  }
}
