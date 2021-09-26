import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/screens/dashboard_devices_continue/components/body.dart';
import 'package:tracker360/screens/dashboard_about_us/about_us.dart';
import 'package:tracker360/screens/dashboard_maps/maps.dart';
import 'package:tracker360/screens/dashboard_reciever/shipment_recieve.dart';
import 'package:tracker360/screens/dashboard_settings/settings.dart';

import 'Firebase/database.dart';
import 'components/loading.dart';
//import 'package:flutter/scheduler.dart' show timeDilation;
// bottom navigation bar:

class MyBottomNavigationbar extends StatefulWidget {
  @override
  _MyBottomNavigationbarState createState() => _MyBottomNavigationbarState();
}

class _MyBottomNavigationbarState extends State<MyBottomNavigationbar> {
  @override
  void initState() {
    super.initState();
    getUserPrivilege();
    // getChildrenList();
  }

  int _currentindex = 0;
  String privilege;
  List<Widget> _trackerIcon;
  List<Widget> _driverIcon;

  List<Widget> _children;
  final List<Widget> _trackerChildren = [
    TagsBody(),
    Maps(),
    Shipment_Recieve(),
    AboutUs(),
    Settings(),
  ];
  final List<Widget> _driverChildren = [
    Maps(),
    AboutUs(),
    Settings(),
  ];

  getIconList() {
    _driverIcon = [
      Icon(
        Icons.location_on,
        size: 30,
        color: getColor(0),
      ),
      Icon(
        Icons.description_sharp,
        size: 30,
        color: (_currentindex == 1) ? kPrimaryColor : Colors.black54,
      ),
      Icon(
        Icons.person,
        size: 30,
        color: (_currentindex == 2) ? kPrimaryColor : Colors.black54,
      ),
    ];

    _trackerIcon = [
      Icon(
        Icons.add_circle,
        size: 30,
        color: (_currentindex == 0) ? kPrimaryColor : Colors.black54,
      ),
      Icon(
        Icons.location_on,
        size: 30,
        color: getColor(1),
      ),
      Icon(
        Icons.wifi_tethering_rounded,
        size: 30,
        color: getColor(2),
      ),
      Icon(
        Icons.description_sharp,
        size: 30,
        color: (_currentindex == 3) ? kPrimaryColor : Colors.black54,
      ),
      Icon(
        Icons.person,
        size: 30,
        color: (_currentindex == 4) ? kPrimaryColor : Colors.black54,
      ),
    ];

    if (privilege == "driver") {
      return _driverIcon;
    } else {
      return _trackerIcon;
    }
  }

  // getChildrenList() {
  //   if (privilege == "driver") {
  //     _children = _driverChildren;
  //   } else {
  //     _children = _trackerChildren;
  //   }
  // }

  Color getColor(int number) {
    if (_currentindex == number) {
      return kPrimaryColor;
    } else {
      return Colors.black54;
    }
  }

  Future<void> getUserPrivilege() async {
    Map<String, dynamic> user = await DatabaseService(
            uid: (await FirebaseAuth.instance.currentUser()).uid)
        .userData();
    setState(() {
      privilege = user["privilege"];
      if (privilege == "driver") {
        _children = _driverChildren;
      } else {
        _children = _trackerChildren;
      }
    });
  }

  void onTappedBar(int index) {
    setState(() {
      _currentindex = index;
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
    return privilege == null
        ? Loading()
        : Form(
            onWillPop: _onBackPressed,
            child: Scaffold(
              body: _children[_currentindex],
              bottomNavigationBar: GestureDetector(
                child: CurvedNavigationBar(
                  onTap: onTappedBar,
                  height: 50,
                  index: _currentindex,
                  items: getIconList(),
                  /*  selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white, */
                ),
              ),
            ),
          );
  }
}
