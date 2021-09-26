import 'package:flutter/material.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/size_config.dart';

// ignore: camel_case_types
class Shipment_Recieve extends StatefulWidget {
  @override
  _Shipment_RecieveState createState() => _Shipment_RecieveState();
}

// ignore: camel_case_types
class _Shipment_RecieveState extends State<Shipment_Recieve> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      //child:
    );
  }
}
