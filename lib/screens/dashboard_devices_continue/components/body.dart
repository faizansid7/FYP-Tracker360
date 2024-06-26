// this file contains tags list functionality and the FAB which contains sending information of the transaction.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/models/shipmentFromSender.dart';
import 'package:tracker360/size_config.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tracker360/Firebase/database.dart';
import 'package:flutter_sms/flutter_sms.dart';

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
    getUserID();
    super.initState();
    populateDrivers();
    // userID = (await FirebaseAuth.instance.currentUser()).uid;
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

  getUserID() async {
    userID = (await FirebaseAuth.instance.currentUser()).uid;
    //return userID;
  }

  tagsList() {
    iTag.clear();
    for (BluetoothDevice device in widget.devicesList) {
      // iTag[] = device.name;

      iTag.addAll([device.name, device.id.toString()]);
    }
  }

  var userID;
  final List<String> errors = [];
  List<String> iTag = [];
  final _formKey = GlobalKey<FormState>();
  List location = ["Location 1", "Loaction 2"];
  String _locStarting;
  String _locEnding;
  int driverPhone;
  int recieverPhone;
  String description;
  String driverName;
  String recieverName;
  String driverEmail;
  List drivers;

  Future<void> populateDrivers() async {
    drivers = await DatabaseService().geDrivers();
    // var a = 0;
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (error.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  FormField locationFieldsStarting() {
    return FormField<String>(
      validator: (value) {
        if (_locStarting != "Location 1" && _locStarting != "Loaction 2") {
          addError(error: kAddressNullError_Tagsbody);
          return "";
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return InputDecorator(
            decoration: InputDecoration(
              labelText: "Location",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
              value: _locStarting,
              hint: Text("Select Location"),
              isDense: true,
              onChanged: (newValue) {
                removeError(error: kAddressNullError_Tagsbody);
                setState(() {
                  _locStarting = newValue;

                  state.didChange(newValue);
                });
              },
              items: location.map((value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
            )));
      },
    );
  }

  FormField driverField() {
    return FormField<String>(
      validator: (value) {
        if (driverEmail == null) {
          addError(error: "Add driver");
          return "";
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return InputDecorator(
            decoration: InputDecoration(
              labelText: "Driver",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/address.svg"),
            ),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
              value: driverEmail,
              hint: Text("Select Driver"),
              isDense: true,
              onChanged: (newValue) {
                removeError(error: "Add driver");
                setState(() {
                  driverEmail = newValue;

                  state.didChange(newValue);
                });
              },
              items: drivers.map((value) {
                return DropdownMenuItem<String>(
                    value: value.last, child: Text(value.first));
              }).toList(),
            )));
      },
    );
  }

  FormField locationFieldsEnding() {
    return FormField<String>(
      validator: (value) {
        if (_locEnding != "Location 1" && _locEnding != "Loaction 2") {
          addError(error: kAddressNullError_Tagsbody);
          return "";
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return InputDecorator(
            decoration: InputDecoration(
              labelText: "Location",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
              value: _locEnding,
              hint: Text("Select Location"),
              isDense: true,
              onChanged: (newValue) {
                removeError(error: kAddressNullError_Tagsbody);
                setState(() {
                  _locEnding = newValue;

                  state.didChange(newValue);
                });
              },
              items: location.map((value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
            )));
      },
    );
  }

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
                widget.flutterBlue.startScan(
                    /* timeout: Duration(seconds: 7) */);
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
          widget.flutterBlue.stopScan();
          tagsList();
          DatabaseService obj = new DatabaseService(
              uid: (await FirebaseAuth.instance.currentUser()).uid);
          var _currentUsername = await obj.userDataByProperty('name');

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
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Sender User Name : $_currentUsername',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                'Enter the Starting Address*',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              // Starting location dropdown

                              locationFieldsStarting(),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                'Enter the Destination Address*',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              // ending locattion dropdown button
                              locationFieldsEnding(),
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
                              TextFormField(
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                onSaved: (newValue) => description = newValue,
                                decoration:
                                    InputDecoration(labelText: 'Description'),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              // driver identification
                              Text(
                                'Driver*',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              driverField(),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                'Driver Phone Number*',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                onSaved: (newValue) =>
                                    driverPhone = int.parse(newValue),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    removeError(error: kDriverPhoneNumbererror);
                                  }
                                  return null;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    addError(error: kDriverPhoneNumbererror);

                                    return "";
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: 'Phone Number'),
                              ),
                              //receiving end person name
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                'Reciever Name*',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.name,
                                onSaved: (newValue) => recieverName = newValue,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    removeError(
                                        error: kRecieverNameError_Tagsbody);
                                  }
                                  return null;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    addError(
                                        error: kRecieverNameError_Tagsbody);

                                    return "";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(labelText: 'Name'),
                              ),

                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                'Recieving Person Phone Number*',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                onSaved: (newValue) =>
                                    recieverPhone = int.parse(newValue),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    removeError(
                                        error: kReeceiverPhoneNumbererror);
                                  }
                                  return null;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    addError(error: kReeceiverPhoneNumbererror);

                                    return "";
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: 'Phone Number'),
                              ),
                              //save button
                              TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    ShipmentFromSender shipment =
                                        new ShipmentFromSender(
                                            currentUsername: _currentUsername,
                                            locEnding: _locEnding,
                                            locStarting: _locStarting,
                                            description: description,
                                            devicesList: iTag,
                                            driverEmail: driverEmail,
                                            driverPhone: driverPhone,
                                            recieverName: recieverName,
                                            recieverPhone: recieverPhone);
                                    var a = await DatabaseService(uid: userID)
                                        .createShipment(shipment);
                                    // Send ID via SMS functionality
                                    List<String> recipents = [];
                                    recipents.clear();
                                    recipents.add(recieverPhone.toString());
                                    String message =
                                        'Your Shipment Details ID is: $a';
                                    await sendSMS(
                                        message: message,
                                        recipients: recipents); //
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  }
                                },
                                child: Text(
                                  'Save and Send',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: Text('Cancel',
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)))
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
