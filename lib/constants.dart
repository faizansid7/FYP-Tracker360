import 'package:flutter/material.dart';

import 'size_config.dart';

const kPrimaryColor = Color(0xFF246BCE);
const kPrimaryLightColor = Color(0xFF4997D0);

const ksecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenHeight(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final RegExp emailValidateRegExp = RegExp(
    (r"^[a-zA-Z0-9.!#$%+/?^_{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"));
const String kEmailNullError = "Please Enter Your Email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter Your Password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNameNullError = "Please enter your Name";
const String kCnicNullError = "Please enter your CNIC";
const String kCnicShortError = "Please enter 13 CNIC Number without '-'";
const String kCnicLongError = "Please enter 13 CNIC Number without '-'";
const String kAddressNullError = "Please enter your Address";
const String kPhoneNumberNullError = "Please enter your Number";
const String kVehicleNullError = 'Please fill above fields';
const String kTrackerNullError = 'Please fill above fields';
const String kUserNameNullError = 'Please enter your Full Name';
const String kDOB_NullError = 'Please enter your Date of Birth';
const String kGenderNullError = 'Please Select your Gender';
const String kDriverPhoneNumbererror = 'Please enter Driver Phone Number';
const String kReeceiverPhoneNumbererror = 'Please enter Reciever Phone Number';
const String kAddressNullError_Tagsbody = "Please enter the Address";
const String kDriverNameError_Tagsbody = 'Please enter the Driver Name';
const String kRecieverNameError_Tagsbody = 'Please enter the Reciever Name';
