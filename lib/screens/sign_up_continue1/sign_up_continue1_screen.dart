import 'package:flutter/material.dart';
import 'package:tracker360/components/custom_svg_icon.dart';
import 'package:tracker360/components/default_button.dart';
import 'package:tracker360/components/form_error.dart';
import 'package:tracker360/constants.dart';
import 'package:tracker360/models/commonRegister.dart';
import 'package:tracker360/screens/driver_tracker/driver_tracker.dart';
import 'package:tracker360/size_config.dart';

class SignUpContinue1 extends StatefulWidget {
  static String routeName = '/sign_up_continue1';
  final CommonRegister commonData;
  SignUpContinue1({@required this.commonData});
  @override
  _SignUpContinue1State createState() => _SignUpContinue1State();
}

class _SignUpContinue1State extends State<SignUpContinue1> {
  final _formKey = GlobalKey<FormState>();

  final List<String> errors = [];

  int cnic;
  List sex = ["Male", "Female"];
  int phoneNumber;
  final dateController = TextEditingController();
  String address;
  DateTime selectedDate = DateTime.now();
  String gender;

  String dateofBirth;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Complete Profile",
                  style: headingStyle,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  "Complete your profile",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(18),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20),
                    ),
                    child: Column(
                      children: [
                        /*   buildUserNameFormField(),
            SizedBox(
              height: getProportionateScreenHeight(28),
            ), */
                        buildCnicFormField(),
                        SizedBox(
                          height: getProportionateScreenHeight(28),
                        ),
                        buildPhoneNumberFormField(),
                        SizedBox(
                          height: getProportionateScreenHeight(28),
                        ),
                        buildAddressFormField(),
                        SizedBox(
                          height: getProportionateScreenHeight(28),
                        ),
                        sexField(),
                        SizedBox(
                          height: getProportionateScreenHeight(28),
                        ),
                        buildDOBFormField(),
                        FormError(errors: errors),
                        SizedBox(
                          height: getProportionateScreenHeight(28),
                        ),
                        DefaultButton(
                          text: "Continue",
                          press: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              widget.commonData.cnic = cnic;
                              widget.commonData.number = phoneNumber;
                              widget.commonData.address = address;
                              widget.commonData.gender = gender;
                              widget.commonData.dob = dateofBirth;
                              print(widget.commonData.password);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return DriverTracker(
                                    commonData: widget.commonData);
                              }));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(18),
                ),
                Text("By continuing you agree to the terms and conditions"),
              ],
            ),
          ),
        ));
  }

  TextFormField buildDOBFormField() {
    return TextFormField(
      readOnly: true,
      controller: dateController,
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kDOB_NullError);

          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Date of Birth",
        hintText: ("Enter your Date of Birth"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/calendar.svg"),
      ),
      onTap: () async {
        final DateTime picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(1947, 1),
            lastDate: DateTime.now());
        if (picked != null && picked != selectedDate)
          setState(() {
            selectedDate = picked;
            dateofBirth = picked.toString();
            dateController.text = picked.toString().substring(0, 10);
            removeError(error: kDOB_NullError);
          });
      },
    );
  }

  FormField sexField() {
    return FormField<String>(
      validator: (value) {
        if (gender != "Male" && gender != "Female") {
          addError(error: kGenderNullError);
          return "";
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return InputDecorator(
            decoration: InputDecoration(
              labelText: "Gender",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/address.svg"),
            ),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
              value: gender,
              hint: Text("Select Gender"),
              isDense: true,
              onChanged: (newValue) {
                removeError(error: kGenderNullError);
                setState(() {
                  gender = newValue;

                  state.didChange(newValue);
                });
              },
              items: sex.map((value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
            )));
      },
    );
  }

  // TextFormField buildGenderFormField() {
  //   return TextFormField(
  //     onSaved: (newValue) => gender = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kGenderNullError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: kGenderNullError);

  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Gender",
  //       hintText: ("Enter your Gender"),
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/address.svg"),
  //     ),
  //   );
  // }

  TextFormField buildAddressFormField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);

          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: ("Enter your Home Address"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/address.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => phoneNumber = int.parse(newValue),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);

          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Contact Number",
        hintText: ("Enter your Contact Number"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/hashtag.svg"),
      ),
    );
  }

  TextFormField buildCnicFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => cnic = int.parse(newValue),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCnicNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kCnicNullError);
          return "";
        } else if (value.length > 13) {
          addError(error: kCnicShortError);
          return "";
        } else if (value.length < 13) {
          addError(error: kCnicLongError);

          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "CNIC",
        hintText: ("Enter 13-digit CNIC number"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/id-card.svg"),
      ),
    );
  }
}
