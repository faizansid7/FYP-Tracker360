import 'dart:io';

import "package:flutter/material.dart";
import 'package:tracker360/Firebase/auth.dart';
import 'package:tracker360/components/custom_svg_icon.dart';
import 'package:tracker360/components/default_button.dart';
import 'package:tracker360/components/form_error.dart';
import 'package:tracker360/components/loading.dart';
import 'package:tracker360/components/no_account_text.dart';
import 'package:tracker360/screens/forgot_password/forgot_password_screen.dart';
import 'package:tracker360/size_config.dart';
import '../../constants.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String email = " ";
  String password = " ";
  String error = " ";
  bool remember = false;
  bool loading = false;
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

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Sign In",
              ),
            ),
            body: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.04),
                        Text(
                          "Welcome",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(28),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.04),
                        Text(
                          "Sign in with your Email and Password",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.08),
                        Form(
                          onWillPop: _onBackPressed,
                          key: _formKey,
                          child: Column(
                            children: [
                              buildEmailFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              buildPasswordFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal:
                              //           getProportionateScreenWidth(02)),
                              //   child: Row(
                              //     children: [
                              //       Checkbox(
                              //         value: remember,
                              //         activeColor: kPrimaryColor,
                              //         onChanged: (value) {
                              //           setState(() {
                              //             remember = value;
                              //           });
                              //         },
                              //       ),
                              //       Text(
                              //         "Remember Me",
                              //         style: TextStyle(
                              //             fontSize:
                              //                 getProportionateScreenHeight(13)),
                              //       ),
                              //       Spacer(),
                              //       GestureDetector(
                              //         onTap: () => Navigator.pushNamed(context,
                              //             ForgotPasswordScreen.routeName),
                              //         child: Text(
                              //           "Forgot Password",
                              //           style: TextStyle(
                              //               decoration:
                              //                   TextDecoration.underline,
                              //               fontSize:
                              //                   getProportionateScreenHeight(
                              //                       13)),
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              FormError(errors: errors),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              DefaultButton(
                                text: "Continue",
                                press: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    _formKey.currentState.save();
                                    dynamic result = await _auth
                                        .signInEmailAndPass(email, password);
                                    if (result != null) {
                                      // Navigator.pushReplacementNamed(context, HeadsUP.routeName);
                                    } else {
                                      setState(() => loading = false);
                                      addError(
                                          error:
                                              "unauthenticated login attempt");
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.08),
                        NoAccountText(),
                        SizedBox(
                          height: getProportionateScreenHeight(26),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: ("Enter your password"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(
          svgIcon: "assets/icons/password.svg",
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (!emailValidateRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);

          return "";
        } else if (!emailValidateRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: ("Enter your email"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/email.svg"),
      ),
    );
  }
}
