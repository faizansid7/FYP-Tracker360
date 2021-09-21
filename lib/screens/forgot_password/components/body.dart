import 'package:flutter/material.dart';
import 'package:tracker360/components/custom_svg_icon.dart';
import 'package:tracker360/components/default_button.dart';
import 'package:tracker360/components/form_error.dart';
import 'package:tracker360/components/no_account_text.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
          child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                        ),
                        child: Column(
        children: [
            SizedBox(height: SizeConfig.screenHeight * 0.1),
            Text(
              "Forgot Password",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(30),
                color: Colors.black,
                fontWeight: FontWeight.bold,
                

              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(28),
            ),
            Text(
              "Please enter your email and we will send \nyou link to return to your account",
              textAlign: TextAlign.center,
                         

            ),
            SizedBox(height: SizeConfig.screenHeight * 0.1),
            ForgotPassForm(),
        ],
        
      ),
                      ),
          ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formkey = GlobalKey<FormState>();
  List<String> errors = [];
  String email;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
        TextFormField(
        keyboardType: TextInputType.emailAddress ,
        onSaved: (newValue) => email = newValue,
        onChanged: (value) {
          if(value.isNotEmpty && errors.contains(kEmailNullError)){
            setState(() {
              errors.remove(kEmailNullError);
            });
            }

            else if (!emailValidateRegExp.hasMatch(value) && 
            errors.contains(kInvalidEmailError)){
              setState(() {
                errors.remove(kInvalidEmailError);
              });
            }
          return null;

        },

        validator: (value) {
          if(value.isEmpty && !errors.contains(kEmailNullError)){
            setState(() {
              errors.add(kEmailNullError);
            }); }

            else if (!emailValidateRegExp.hasMatch(value) && 
            !errors.contains(kInvalidEmailError)){
              setState(() {
                errors.add(kInvalidEmailError);
              });
            }
          return null;
        },
        decoration: InputDecoration(
             labelText: "Email",
          hintText: ("Enter your email"),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(
            svgIcon: "assets/icons/email.svg",
          ),
          ),
    
    ),
    SizedBox(height: getProportionateScreenHeight(30)),
    FormError(errors: errors),
    SizedBox(height: SizeConfig.screenHeight * 0.01),
    DefaultButton(
      text: "Continue",
      press: (){
        if (_formkey.currentState.validate()){
          
        }
      },
    ),
    SizedBox(height: SizeConfig.screenHeight * 0.01),
    SizedBox(
              height: getProportionateScreenHeight(28),
            ),
    NoAccountText(),
        ],),
    );
  }
}