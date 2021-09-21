import 'package:flutter/material.dart';
import 'package:tracker360/Firebase/auth.dart';
import 'package:tracker360/navigation_bar.dart';

class   DevicesScreen extends StatelessWidget {
  static String routeName = "/dashboard_devices_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyBottomNavigationbar(),
    );
  }
}
