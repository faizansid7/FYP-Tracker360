import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tracker360/Firebase/database.dart';
import 'package:tracker360/components/loading.dart';
import 'package:tracker360/models/driverRegister.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  @override
  void initState() {
    super.initState();
    getPrivilege();
  }

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  String privilege;
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  TextEditingController textEditingController = TextEditingController();

  bool typing = false;
  FocusNode focusNode = FocusNode();
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(24.8607, 67.0011),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/icons/sedan.svg");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latLng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latLng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latLng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();

    // getUserPrivilege();
  }

  void getPrivilege() async {
    var a = await DatabaseService(
            uid: (await FirebaseAuth.instance.currentUser()).uid)
        .userDataByProperty("privilege");
    setState(() {
      privilege = a;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Are you sure you want to quit?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () => exit(0),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: privilege == 'driver'
            ? null
            : AppBar(
                automaticallyImplyLeading: false,
                title: TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: ("Enter the driver email to locate"),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    contentPadding: EdgeInsets.only(
                        left: 10, bottom: 30, top: 21, right: 25),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.gps_fixed_outlined,
                      ),
                      onPressed: () async {
                        focusNode.canRequestFocus = false;
                        if (textEditingController.text.trim().isNotEmpty) {
                          DatabaseService()
                              .getDriverLocation(
                                  textEditingController.text.trim())
                              .listen((qs) {
                            DocumentSnapshot driverDoc = qs.documents.first;
                            DriverRegister driver =
                                DriverRegister.fromJson(driverDoc.data);
                            print("---------");
                            print(
                                "Driver's Latitude: " + driver.lat.toString());
                            print(
                                "Driver's Longitude: " + driver.lng.toString());

                            setState(() {
                              marker = Marker(
                                markerId: MarkerId("loc"),
                                position: LatLng(driver.lat, driver.lng),
                                infoWindow:
                                    InfoWindow(title: "Live Driver Location"),
                              );

                              _controller.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                      LatLng(driver.lat, driver.lng), 16));

                              // //Do the marker working here.
                            });
                          });
                        } else {
                          print("masla ha");
                        }
                      },
                    ),
                  ),
                ),
              ),
        body: GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: initialLocation,
          markers: Set.of((marker != null) ? [marker] : []),
          circles: Set.of((circle != null) ? [circle] : []),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 270.0),
          child: FloatingActionButton(
              child: Icon(Icons.location_searching),
              onPressed: () {
                getCurrentLocation();
              }),
        ),
      ),
    );
  }
}
