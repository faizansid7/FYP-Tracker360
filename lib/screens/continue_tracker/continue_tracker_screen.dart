import 'package:flutter/material.dart';
import 'package:tracker360/Firebase/auth.dart';
import 'package:tracker360/Firebase/database.dart';
import 'package:tracker360/components/custom_svg_icon.dart';
import 'package:tracker360/components/default_button.dart';
import 'package:tracker360/components/form_error.dart';
import 'package:tracker360/components/loading.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/models/commonRegister.dart';
import 'package:tracker360/models/trackerRegister.dart';
import 'package:tracker360/screens/sign_in/sign_in_screen.dart';
import 'package:tracker360/screens/wrapper.dart';
import 'package:tracker360/size_config.dart';

class ContinueTracker extends StatefulWidget {
  static String routeName = "/continue_tracker";
  final CommonRegister commonData;
  ContinueTracker({@required this.commonData});
  @override
  _ContinueTrackerState createState() => _ContinueTrackerState();
}

class _ContinueTrackerState extends State<ContinueTracker> {
  final _formkey = GlobalKey<FormState>();
  String organizationName;
  String employeeId;
  String employeeDesignation;
  bool loading = false;
  final List<String> errors = [];
  AuthService _auth = AuthService();
  DatabaseService _database = DatabaseService();

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
              title: Text("TRACKER"),
            ),
            body: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      Text(
                        "Tracker Login",
                        style: headingStyle,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Text(
                        "Complete your details",
                        textAlign: TextAlign.center,
                      ),
                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: getProportionateScreenHeight(78),
                            ),
                            buildOrganizationNameFormField(),
                            SizedBox(
                              height: getProportionateScreenHeight(28),
                            ),
                            buildEmployeeDesignationFormField(),
                            SizedBox(
                              height: getProportionateScreenHeight(28),
                            ),
                            buildEmployeeIdFormField(),
                            FormError(errors: errors),
                            SizedBox(
                              height: getProportionateScreenHeight(28),
                            ),
                            DefaultButton(
                              text: "Continue",
                              press: () async {
                                if (_formkey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  _formkey.currentState.save();
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          widget.commonData.email,
                                          widget.commonData.password);
                                  if (result != null) {
                                    TrackerRegister tracker =
                                        new TrackerRegister(
                                            widget.commonData,
                                            employeeDesignation,
                                            employeeId,
                                            organizationName);
                                    await DatabaseService(uid: result.uid)
                                        .addTracker(tracker);
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Wrapper()),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    setState(() {
                                      loading = true;
                                    });
                                    addError(error: "Authetication failed");
                                  }
                                  // Navigator.pushNamed(
                                  //     context, SignInScreen.routeName);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  TextFormField buildEmployeeIdFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => organizationName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kTrackerNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kTrackerNullError);

          return "";
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: "Employee ID",
        hintText: "Enter your Employee ID",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(
          svgIcon: "assets/icons/employee.svg",
        ),
      ),
    );
  }

  TextFormField buildEmployeeDesignationFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => employeeDesignation = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kTrackerNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kTrackerNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Employee Designation",
        hintText: "Enter your Designation",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(
          svgIcon: "assets/icons/manager.svg",
        ),
      ),
    );
  }

  TextFormField buildOrganizationNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => employeeId = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kTrackerNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kTrackerNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Organization Name",
        hintText: "Enter your Oragnization name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(
          svgIcon: "assets/icons/organization.svg",
        ),
      ),
    );
  }
}
