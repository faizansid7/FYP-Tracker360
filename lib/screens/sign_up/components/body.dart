import 'package:flutter/material.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/screens/sign_up/components/sign_up_form.dart';
import 'package:tracker360/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              Text(
                "Register Account",
                style: headingStyle,
              ),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              Text(
                "Complete your details",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              SignUpForm(),
              SizedBox(
                height: getProportionateScreenHeight(18),
              ),
              Text("By continuing you agree to the terms and conditions"),
            ],
          ),
        ),
      ),
    );
  }
}
