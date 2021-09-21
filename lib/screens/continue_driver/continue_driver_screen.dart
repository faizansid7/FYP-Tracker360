import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker360/Firebase/auth.dart';
import 'package:tracker360/Firebase/database.dart';
import 'package:tracker360/components/custom_svg_icon.dart';
import 'package:tracker360/components/default_button.dart';
import 'package:tracker360/components/form_error.dart';
import 'package:tracker360/components/loading.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/driver_provider.dart';
import 'package:tracker360/models/commonRegister.dart';
import 'package:tracker360/models/driverRegister.dart';
import 'package:tracker360/screens/sign_in/sign_in_screen.dart';
import 'package:tracker360/screens/wrapper.dart';
import 'package:tracker360/size_config.dart';

class ContinueDriver extends StatefulWidget {
  static String routeName = "/continue_driver";
  final CommonRegister commonData;
  ContinueDriver({@required this.commonData});

  @override
  _ContinueDriverState createState() => _ContinueDriverState();
}

class _ContinueDriverState extends State<ContinueDriver> {
  final _formkey = GlobalKey<FormState>();
  String vehicleNum;
  String vehicleMake;
  String vehicleModel;
  bool loading = false;
  AuthService _auth = AuthService();
  // DatabaseService _dbService = DatabaseService();
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("DRIVER"),
            ),
            body: SizedBox(
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
                        "Driver Login",
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
                        height: getProportionateScreenHeight(30),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.05),
                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            buildVehicleMakeFormField(),
                            SizedBox(
                              height: getProportionateScreenHeight(28),
                            ),
                            buildVehicleModelFormField(),
                            SizedBox(
                              height: getProportionateScreenHeight(28),
                            ),
                            buildVehicleNumFormField(),
                            FormError(errors: errors),
                            SizedBox(
                              height: getProportionateScreenHeight(48),
                            ),
                            DefaultButton(
                                text: 'Continue',
                                press: () async {
                                  if (_formkey.currentState.validate()) {
                                    _formkey.currentState.save();
                                    setState(() => loading = true);
                                    print(widget.commonData.password);
                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                            widget.commonData.email,
                                            widget.commonData.password);
                                    if (result != null) {
                                      print(result);
                                      DriverRegister driver =
                                          new DriverRegister(
                                              common: widget.commonData,
                                              model: vehicleModel,
                                              regNumber: vehicleNum,
                                              driverId: result.uid,
                                              vehicleMake: vehicleMake);
                                      await DatabaseService(uid: result.uid)
                                          .addDriver(driver);
                                      UserProvider driverProvider =
                                          Provider.of<UserProvider>(context,
                                              listen: false);
                                      driverProvider.setCurrentDriver(driver);

                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => Wrapper()),
                                          (Route<dynamic> route) => false);
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                      addError(error: "authentication failed");
                                    }
                                  }
                                }),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  TextFormField buildVehicleModelFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => vehicleModel = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kVehicleNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kVehicleNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Vehicle Model",
        hintText: ("Enter your Vehicle Model"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/towing-vehicle.svg"),
      ),
    );
  }

  TextFormField buildVehicleMakeFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => vehicleMake = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kVehicleNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kVehicleNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Vehicle Make",
        hintText: ("Enter your Vehcile Make"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/towing-vehicle.svg"),
      ),
    );
  }

  TextFormField buildVehicleNumFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => vehicleNum = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kVehicleNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kVehicleNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Vehicle Number",
        hintText: ("Enter your Vehicle Number"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/towing-vehicle.svg"),
      ),
    );
  }
}
