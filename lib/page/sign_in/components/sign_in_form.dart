// Libraries
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touch/util/size_config.dart';
import 'package:touch/util/validator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touch/util/app_constant.dart';
import 'package:touch/util/app_localizations.dart';

// Components
import 'package:touch/widget/form_error.dart';
import 'package:touch/widget/default_button.dart';

// Sin In Form
class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>(); // control

  // Variables
  String email;
  String password;
  var _controller = TextEditingController();
  var _controllerpassword = TextEditingController();

  // Remember Me (Easy way to Sign in)
  bool rememberMe = false;
  bool _showPassword = false; // private variable

  // Error (Multiple Error)
  final List<String> formErrors = [];

  // Add Error
  void addError(String error) {
    if (!formErrors.contains(error)) {
      setState(() {
        formErrors.add(error);
      });
    }
  }

  // Remove Error
  void removeError(String error) {
    if (formErrors.contains(error)) {
      setState(() {
        formErrors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // E-mail
          buildEmailFormField(),
          // Sizedbox for Responsive Design
          SizedBox(height: getProportionateScreenHeight(15)),
          // Password
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(5)),

          // Remember Me checkbox (?) & Forgot Password
          Row(
            children: <Widget>[
              Spacer(),
              // Forgot Password (Not a Button)
              GestureDetector(
                onTap: () => {
                  Navigator.pushNamed(context, AppConstant.pageForgotPassword),
                },
                child: Text(
                  AppLocalizations.getString(AppConstant.kForgetPasswordText),
                  style: TextStyle(
                    color: AppConstant.kPrimaryColor,
                  ),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(5),
              ),
            ],
          ),

          // Sign in button
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: AppLocalizations.getString(AppConstant.kSignInText),
            buttonColor: AppConstant.kPrimaryColor,
            textColor: Colors.white,
            press: () {
              if ((_formKey.currentState.validate()) &&
                  (formErrors.isEmpty == true)) {
                _formKey.currentState.save();
                // Access to Login success page
                Navigator.popAndPushNamed(
                    context, AppConstant.pageLoginSuccess);
              }
            },
          ),

          // Form Error
          SizedBox(height: getProportionateScreenHeight(15)),
          FormError(errors: formErrors),
        ],
      ),
    );
  }

  // E-mail TextField
  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _controller,
      cursorColor: AppConstant.kPrimaryColor,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (Validator().validateEmail(value) != null) {
          if (formErrors.contains(
              AppLocalizations.getString(AppConstant.kEmailNullError))) {
            removeError(
                AppLocalizations.getString(AppConstant.kEmailNullError));
          } else if (formErrors.contains(
              AppLocalizations.getString(AppConstant.kInvalidEmailError))) {
            removeError(
                AppLocalizations.getString(AppConstant.kInvalidEmailError));
          } else {
            removeError(
                AppLocalizations.getString(AppConstant.kEmailNullError));
            removeError(
                AppLocalizations.getString(AppConstant.kInvalidEmailError));
          }
        }
      },
      validator: (value) {
        if (Validator().validateEmail(value) != null) {
          addError(Validator().validateEmail(value));
          return ''; // Border must be red
        }
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.getString(AppConstant.kEmailText),
        labelStyle: TextStyle(
          color: AppConstant.kSecondaryColor,
        ),
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: TextStyle(height: 0),
        border: outlineInputBorder(),
        enabledBorder: outlineInputBorder(),
        focusedBorder: outlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(30),
            vertical: getProportionateScreenWidth(9)),

        // Icon
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: () => _controller.clear(),
                icon: Icon(Icons.clear),
              ),

        /*suffixIcon: IconButton(
          onPressed: () => _controller.clear(),
          icon: Icon(Icons.clear),
        ),*/

        prefixIcon: Padding(
          padding: EdgeInsets.fromLTRB(
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(20),
          ),
          child: SvgPicture.asset(
            "assets/icons/Mail.svg",
            height: getProportionateScreenWidth(18),
          ),
        ),
      ),
    );
  }

  // Password TextField
  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _controllerpassword,
      cursorColor: AppConstant.kPrimaryColor,
      obscureText: !_showPassword,
      enableSuggestions: false,
      autocorrect: false,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (Validator().validatePasswordLength(value) != null) {
          if (formErrors.contains(
              AppLocalizations.getString(AppConstant.kPassNullError))) {
            removeError(AppLocalizations.getString(AppConstant.kPassNullError));
          } else if (formErrors.contains(
              AppLocalizations.getString(AppConstant.kShortPassError))) {
            removeError(
                AppLocalizations.getString(AppConstant.kShortPassError));
          }
        }
      },
      validator: (value) {
        if (Validator().validatePasswordLength(value) != null) {
          addError(Validator().validatePasswordLength(value));
          return ''; // Border must be red
        }
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.getString(AppConstant.kPasswordText),
        labelStyle: TextStyle(
          color: AppConstant.kSecondaryColor,
        ),
        //floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: TextStyle(height: 0),
        border: outlineInputBorder(),
        enabledBorder: outlineInputBorder(),
        focusedBorder: outlineInputBorder(),

        contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(30),
            vertical: getProportionateScreenWidth(9)),

        // Show Password
        suffixIcon: _controllerpassword.text.isEmpty
            ? null
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                child: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),

        // Icon
        prefixIcon: Padding(
          padding: EdgeInsets.fromLTRB(
            getProportionateScreenWidth(25),
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(25),
            getProportionateScreenWidth(20),
          ),
          child: SvgPicture.asset(
            "assets/icons/Lock.svg",
            height: getProportionateScreenWidth(18),
          ),
        ),
      ),
    );
  }

  // Show Alert (Sign In Failed)
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: FormError(errors: formErrors),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
