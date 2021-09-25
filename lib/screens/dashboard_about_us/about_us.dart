import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/size_config.dart';
import 'package:tracker360/permissions.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    super.initState();
    askLocation();
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          shadowColor: kPrimaryColor,
          elevation: 7,
          title: Text(
            'About',
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenWidth(30),
            ),
          ),
          leading: Icon(
            Icons.person_outline_sharp,
            color: Colors.black54,
          ),
          titleSpacing: -3,
        ),
        body: NewWidget(),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              Text(
                'Tracker360 is a tracking application.                 ',
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(20),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),
              Text(
                'Tracker360 app is built for both IOS and Android devies.',
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(20),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),
              Text(
                'Tracker360 is a user-friendly application. ',
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(20),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              Text(
                'Tracker360 is built for security purposes.   ',
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(20),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              Text(
                'Tracker360 have many use cases.    ',
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
