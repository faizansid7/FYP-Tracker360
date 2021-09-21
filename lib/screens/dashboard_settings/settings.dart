import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker360/Firebase/auth.dart';
import 'package:tracker360/Firebase/database.dart';
import 'package:tracker360/components/loading.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/driver_provider.dart';
import 'package:tracker360/screens/sign_in/sign_in_screen.dart';
import 'package:tracker360/screens/wrapper.dart';
import 'package:tracker360/size_config.dart';
import 'package:tracker360/permissions.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

bool value = true;

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  bool loading = false;
  int phone;
  String email;
  String gender;
  String address;

  @override
  void initState() {
    super.initState();
    askLocation();
    loadAllValues();
  }

  Future<dynamic> getValue(prop) async {
    return await DatabaseService(
            uid: (await FirebaseAuth.instance.currentUser()).uid)
        .userDataByProperty(prop);
  }

  void loadAllValues() async {
    email = await getValue("email");
    phone = await getValue("contact.No");
    gender = await getValue("gender");
    address = await getValue("address");
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              shadowColor: kPrimaryColor,
              elevation: 7,
              title: Text(
                'Settings',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(30),
                ),
              ),
              leading: Icon(
                Icons.settings,
                color: Colors.black54,
              ),
              titleSpacing: -3,
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Common ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.public,
                              color: Colors.black45,
                            ),
                            title: Text("Language"),
                            subtitle: Text(
                              "(English)",
                              style: TextStyle(color: Colors.black45),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Account ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.phone,
                              color: Colors.black45,
                            ),
                            title: Text("Phone Number"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => new AlertDialog(
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  title: Text(
                                    'Phone Number',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(this.phone.toString()),
                                  ),
                                ),
                              );
                              // var a = await getValue("contact.No");
                            },
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.email,
                              color: Colors.black45,
                            ),
                            title: Text("Email"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => new AlertDialog(
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  title: Text(
                                    'Email',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(this.email),
                                  ),
                                ),
                              );
                            },
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.group_outlined,
                              color: Colors.black45,
                            ),
                            title: Text("Gender"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => new AlertDialog(
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  title: Text(
                                    'Gender',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(this.gender),
                                  ),
                                ),
                              );
                            },
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.add_location,
                              color: Colors.black45,
                            ),
                            title: Text("Address"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => new AlertDialog(
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  title: Text(
                                    'Address',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(this.address),
                                  ),
                                ),
                              );
                            },
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.subdirectory_arrow_right,
                              color: Colors.black45,
                            ),
                            title: Text("Signout"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              UserProvider userProv = Provider.of<UserProvider>(
                                  context,
                                  listen: false);
                              setState(() {
                                loading = true;
                              });
                              await _auth.signout().then((value) {
                                print("Value: $value");
                                userProv.cancelTimer();
                                userProv.resetprovider();
                              }).whenComplete(() {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => Wrapper()),
                                    (Route<dynamic> route) => false);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // Text(
                    //   "Security ",
                    //   style: TextStyle(
                    //       color: kPrimaryColor,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 15),
                    // ),
                    // Card(
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: Column(children: [
                    //     ListTile(
                    //       leading: Icon(
                    //         Icons.lock,
                    //         color: Colors.black45,
                    //       ),
                    //       title: Text("Change Password"),
                    //       trailing: Icon(Icons.keyboard_arrow_right),
                    //     ),
                    //     Container(
                    //       height: 1,
                    //       color: Colors.grey.shade200,
                    //       width: double.infinity,
                    //     ),
                    //     ListTile(
                    //       leading: Icon(
                    //         Icons.person_outline_outlined,
                    //         color: Colors.black45,
                    //       ),
                    //       title: Text("Change Username"),
                    //       trailing: Icon(Icons.keyboard_arrow_right),
                    //     ),
                    //   ]),
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Notifications ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          SwitchListTile(
                            value: true,
                            title: Text("Allow Notifications"),
                            onChanged: (val) {},
                            activeColor: kPrimaryColor,
                          )
                        ])),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "History ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(children: [
                        ListTile(
                          leading: Icon(
                            Icons.local_shipping_outlined,
                            color: Colors.black45,
                          ),
                          title: Text("Shipment History"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Theme",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          SwitchListTile(
                            value: false,
                            title: Text("Dark Mode"),
                            onChanged: (val) {},
                            activeColor: kPrimaryColor,
                          )
                        ])),
                  ]),
            )));
  }
}
