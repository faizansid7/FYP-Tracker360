import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker360/Firebase/database.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/size_config.dart';

// ignore: camel_case_types
class Shipment_Recieve extends StatefulWidget {
  @override
  _Shipment_RecieveState createState() => _Shipment_RecieveState();
}

// ignore: camel_case_types
class _Shipment_RecieveState extends State<Shipment_Recieve> {
  String driverPhone;
  String description;
  String drivername;
  String recieverName;
  String recieverphone;
  String senderName;
  String dropOff;
  String pickUp;
  List tags = [];
  String error = "";

  Future<void> getShipmentData() async {
    Map<String, dynamic> shipment = await DatabaseService(
            uid: (await FirebaseAuth.instance.currentUser()).uid)
        .shipmentData(uID);
    if (shipment != null) {
      setState(() {
        error = "";
        driverPhone = shipment["DriverPhoneNo."].toString();
        description = shipment["Description_Shipment"];
        drivername = shipment["DriverName"];
        recieverName = shipment["RecieverName"];
        recieverphone = shipment["RecieverPhoneNO."].toString();
        senderName = shipment["SenderUserName"];
        dropOff = shipment["ShipmentDropOff"];
        pickUp = shipment["ShipmentPickupLoc"];
        tags = shipment["TagsList"];
      });
    } else {
      setState(() {
        error = "Wrong shipment ID";
        driverPhone = '';
        description = "";
        drivername = '';
        recieverName = '';
        recieverphone = '';
        senderName = '';
        dropOff = '';
        pickUp = '';
        tags = [];
      });
    }
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

  /*  Future<void> getUserPrivilege() async {
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
  } */
  String uID;

  @override
  Widget build(BuildContext context) {
    return Form(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: kPrimaryColor,
            elevation: 7,
            title: Text(
              'Shipment Details',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(30)),
            ),
            leading: Icon(
              Icons.local_shipping_outlined,
              color: Colors.black54,
            ),
            titleSpacing: -3,
          ),
          body: SingleChildScrollView(
            child: /* Stack( */
                Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (newvalue) => uID = newvalue,
                      enableInteractiveSelection: true,
                      //obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Shipment ID',
                        hintText: 'Enter Shipment Unique ID',
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      getShipmentData();
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(40),
                  ),
                  Text("$error"),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text("Driver Name: $drivername",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text("Driver Phone Number: $driverPhone ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text("Reciever Name: $recieverName",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text("Reciever Phone Number: $recieverphone",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text("Sender Name: $senderName",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text("Shipment DropOff location: $dropOff",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text("Shipment Pickup Location: $pickUp",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text("Discription: $description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text("Tags List: $tags",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
