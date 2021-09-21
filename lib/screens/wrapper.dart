import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker360/models/user.dart';
import 'package:tracker360/headsUp.dart';
import 'package:tracker360/screens/sign_in/sign_in_screen.dart';
import 'package:tracker360/size_config.dart';

class Wrapper extends StatelessWidget {
  @override
  static String routeName = "/wrapper";
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final user = Provider.of<User>(context);

    if (user == null) {
      return SignInScreen();
      //SplashScreen();
    } else {
      return HeadsUP();
    }
    //return based on state
  }
}
