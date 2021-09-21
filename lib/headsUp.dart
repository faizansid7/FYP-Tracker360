import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tracker360/Firebase/auth.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/driver_provider.dart';
import 'package:tracker360/models/user.dart';
import 'package:tracker360/screens/dashboard_devices_continue/devices_screen.dart';
//import 'package:tracker360/sender_reciever.dart';
import 'package:tracker360/size_config.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'components/loading.dart';

class HeadsUP extends StatefulWidget {
  static String routeName = "/HeadsUp";

  @override
  _HeadsUPState createState() => _HeadsUPState();
}

class _HeadsUPState extends State<HeadsUP> {
  bool loading = false;
  UserProvider userProv;
  setDriverToProvider() async {
    await userProv.setCurrentDriverFromDB();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final user = Provider.of<User>(context);
    // print("object : " + user.uid);
    userProv = Provider.of<UserProvider>(context, listen: false);
    setDriverToProvider();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: kPrimaryColor,
            body: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(170)),
                Text(
                  "Tracker 360",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(36),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),
                Text(
                  "Make sure your Location service, Bluetooth service and Internet connectivity service is enabled for better useablity of this app ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),
                FlatButton(
                  onPressed: () async {
                    setState(() => loading = true);
                    FlutterBlue.instance.state.listen((state) {
                      if (state == BluetoothState.off) {
                        setState(() => loading = false);
                        //if bluetooth is disabled then stop.
                        showAlertDialog(context);
                      } else if (state == BluetoothState.on) {
                        //if bluetooth is enabled then go ahead.
                        Navigator.pushNamed(context, DevicesScreen.routeName);
                      }
                    });
                  },
                  child: Text(
                    "Relax, I got it!",
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  color: Colors.white,
                )
              ],
            ),
          );
  }
}

//alert dialog if ble is not active
showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Bluetooth Alert"),
    content: Text(
        "You need to enable your Bluetooth sevice in order to use this app properly."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
