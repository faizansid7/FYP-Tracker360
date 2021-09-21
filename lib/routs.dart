//import 'dart:js';

import 'package:flutter/widgets.dart';
import 'package:tracker360/headsUp.dart';
//import 'package:tracker360/screens/continue_driver/continue_driver_screen.dart';
//import 'package:tracker360/screens/continue_tracker/continue_tracker_screen.dart';
import 'package:tracker360/screens/dashboard_devices_continue/devices_screen.dart';
//import 'package:tracker360/screens/driver_tracker/driver_tracker.dart';
import 'package:tracker360/screens/forgot_password/forgot_password_screen.dart';
import 'package:tracker360/screens/sign_in/sign_in_screen.dart';
import 'package:tracker360/screens/sign_up/sign_up_screen.dart';
//import 'package:tracker360/screens/sign_up_continue1/sign_up_continue1_screen.dart';
import 'package:tracker360/screens/splash/splash_screen.dart';
import 'package:tracker360/screens/wrapper.dart';
//import 'package:tracker360/sender_reciever.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpscreen.routeName: (context) => SignUpscreen(),
  //SignUpContinue1.routeName: (context) => SignUpContinue1(),
  //DriverTracker.routeName: (context) => DriverTracker(),
  //ContinueDriver.routeName: (context) => ContinueDriver(),
  // ContinueTracker.routeName: (context) => ContinueTracker(),
  DevicesScreen.routeName: (context) => DevicesScreen(),
  HeadsUP.routeName: (context) => HeadsUP(),
  Wrapper.routeName: (context) => Wrapper(),
  // sender_reciever.routeName: (context) => sender_reciever()
};
