import 'package:flutter/material.dart';
import 'package:tracker360/screens/splash/components/body.dart';
import 'package:tracker360/size_config.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/spllash";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
      
    );
  }
}