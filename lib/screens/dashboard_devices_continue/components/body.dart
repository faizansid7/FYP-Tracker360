// this file contains tags list functionality and the FAB which contains sending information of the transaction.

import 'package:flutter/material.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/size_config.dart';
import 'package:flutter_blue/flutter_blue.dart';

class TagsBody extends StatefulWidget {
  @override
  _TagsBodyState createState() => _TagsBodyState();
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
}

class _TagsBodyState extends State<TagsBody> {
  //var TagsCount;

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  var Ending_location_value = 1;
  var Starting_location_value = 2;

  @override
  Widget build(BuildContext context) {
    //var tagsCount = TagsCount;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: kPrimaryColor,
        elevation: 7,
        title: Text(
          'Tags list',
          style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenWidth(30)),
        ),
        leading: Icon(
          Icons.track_changes,
          color: Colors.black54,
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                widget.flutterBlue.startScan(timeout: Duration(seconds: 7));
              },
              child: Icon(
                Icons.search,
                size: 26.0,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
        titleSpacing: -3,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_rounded),
        backgroundColor: kPrimaryColor,
        onPressed: () async {
          //alert dialog for sender and reciever selection
          await showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => new AlertDialog(
                    insetPadding: EdgeInsets.symmetric(horizontal: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    title: Text(
                      'Sending Information',
                      style: TextStyle(color: Colors.black),
                    ),
                    scrollable: true,
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          child: Column(
                        children: <Widget>[
                          Text(
                            'Enter the Starting Address',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          // Starting location dropdown
                          DropdownButton(
                            value: Starting_location_value,
                            items: [
                              DropdownMenuItem(
                                  child: Text('Location1'), value: 1),
                              DropdownMenuItem(
                                child: Text('Location2'),
                                value: 2,
                              )
                            ],
                            onChanged: (int value) {
                              setState(() {
                                Starting_location_value = value;
                              });
                            },
                            hint: Text('Select your Location '),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Text(
                            'Enter the Destination Address',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          // ending locattion dropdown button
                          DropdownButton(
                            value: Ending_location_value,
                            items: [
                              DropdownMenuItem(
                                  child: Text('Location1'), value: 1),
                              DropdownMenuItem(
                                child: Text('Location 2'),
                                value: 2,
                              )
                            ],
                            onChanged: (int value) {
                              setState(() {
                                Ending_location_value = value;
                              });
                            },
                            hint: Text('Select your Location '),
                          ),
                          // description textfield for the shipment
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Text(
                            'Description about the shipment',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          TextField(
                            maxLines: null,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          // driver identification
                          Text(
                            'Driver Username',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Username'),
                          ),
                          //receiving end person name
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Text(
                            'Recieving End Person Name',
                            style: TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Username'),
                          ),
                          //save button
                          TextButton(
                            onPressed: null,
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          )
                        ],
                      )),
                    ),
                  ));
        },
      ),
      body: _buildListViewOfDevices(),
    );
  }
}
