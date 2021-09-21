import 'package:flutter/material.dart';
import 'package:tracker360/components/default_button.dart';
import 'package:tracker360/models/commonRegister.dart';
import 'package:tracker360/screens/continue_driver/continue_driver_screen.dart';
import 'package:tracker360/screens/continue_tracker/continue_tracker_screen.dart';
import 'package:tracker360/size_config.dart';

class DriverTracker extends StatefulWidget {
  final CommonRegister commonData;
  static String routeName = "/driver_tracker";
  DriverTracker({@required this.commonData});

  @override
  _DriverTrackerState createState() => _DriverTrackerState();
}

class _DriverTrackerState extends State<DriverTracker> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(200),
              ),
              DefaultButton(
                text: "DRIVER",
                press: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print(widget.commonData.gender);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ContinueDriver(commonData: widget.commonData);
                    }));
                    //Navigator.pushNamed(context, ContinueDriver.routeName);
                  }
                },
              ),
              SizedBox(
                height: getProportionateScreenHeight(90),
              ),
              DefaultButton(
                text: "TRACKER",
                press: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ContinueTracker(commonData: widget.commonData);
                    }));
                    // Navigator.pushNamed(context, ContinueTracker.routeName);
                  }
                },
              ),
            ],
          ),
        ));
  }
}
