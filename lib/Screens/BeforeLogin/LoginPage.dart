import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../InterfaceFunc/snackBarInformation.dart';
import '../../Validation/LoginRegisterValidations/LoginValidator.dart';

bool _passwordInvisible = true;

class FormData {
  String? email;
  String? password;

  FormData({
    this.email,
    this.password,
  });
}

class LoginPage extends StatefulWidget {
  static const routeName = "/LoginPage";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State with UserValidationMixin {
  final _formKey = GlobalKey<FormState>();
  FormData formData = FormData();

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        } // When not focused to Form TextFormFields',
        // keyboard will be lost automatically.
      },
      child: Scaffold(
          body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(_deviceWidth / 45),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _deviceHeight / 45,
              ),
              _hamMenuAndTitle(_deviceWidth),
              SizedBox(
                height: _deviceHeight / 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildEmailField(),
                    buildPasswordField(),
                    forgotPassword(_deviceHeight, _deviceWidth),
                    buildSignInButton(_deviceHeight, _deviceWidth),
                  ],
                ),
              ),
              SizedBox(
                height: _deviceHeight / 45,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 4,
                    child: Divider(color: Colors.black, thickness: 2),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "OR",
                      style: GoogleFonts.openSans(
                          fontSize: _deviceWidth / 21,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(
                    flex: 4,
                    child: Divider(color: Colors.black, thickness: 2),
                  ),
                ],
              ),
              SizedBox(
                height: _deviceHeight / 60,
              ),
              Text(
                "Connect with",
                style: GoogleFonts.openSans(
                    fontSize: _deviceWidth / 21,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: _deviceHeight / 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: Image.asset(
                        "lib/Assets/WashMe/BeforeLogin/Login/phone.png",
                        height: _deviceWidth/8,
                      ),
                  ),
                  Expanded(
                      child: Image.asset(
                        "lib/Assets/WashMe/BeforeLogin/Login/google.png",
                        height: _deviceWidth/8,
                      ),),
                  Expanded(
                      child: Image.asset(
                        "lib/Assets/WashMe/BeforeLogin/Login/facebook.png",
                        height: _deviceWidth/8,
                      ),),
                ],
              ),
              SizedBox(
                height: _deviceHeight / 45,
              ),
              const Divider(color: Colors.black, thickness: 2),
              SizedBox(
                height: _deviceHeight / 60,
              ),
              createAccount(_deviceWidth),
            ],
          ),
        ),
      )),
    );
  }

  Widget buildEmailField() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: (value) => validateEmail(value.toString()),
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Colors.black,
          ),
          fillColor: Colors.white,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 4),
          ),
          filled: true,
          hintText: 'info@roadeo.com',
          labelText: 'Email',
        ),
        onChanged: (String value) => formData.email = value.trim(),
      ),
    );
  }

  Widget buildPasswordField() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: TextFormField(
        validator: (value) => validatePassword(value.toString()),
        obscureText: _passwordInvisible,
        decoration: InputDecoration(
          fillColor: Colors.white,
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          filled: true,
          labelText: 'Password',
          hintText: "abcd123",
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Colors.black,
          ),
          suffixIcon: IconButton(
            color: Colors.black,
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordInvisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordInvisible = !_passwordInvisible;
              });
            },
          ),
        ),
        onChanged: (String value) {
          formData.password = value.trim();
        },
      ),
    );
  }

  Widget buildSignInButton(double deviceHeight, double deviceWidth) {
    return ElevatedButton(
        child: Container(
          margin: EdgeInsets.only(
              top: deviceHeight / 42,
              bottom: deviceHeight / 42,
              left: deviceWidth / 5,
              right: deviceWidth / 5),
          child: Text(
            'Login',
            style: GoogleFonts.openSans(fontSize: deviceHeight / 35),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () async {
          FocusScope.of(context).unfocus();

          if (_formKey.currentState!.validate()) {

            try {

              User? anonymousUser = FirebaseAuth.instance.currentUser;

              await _submitAuthForm(
                email: formData.email.toString().trim(),
                password: formData.password.toString().trim(),
              );

              FirebaseFirestore.instance.collection("users").doc(anonymousUser!.uid).delete();

              if(!mounted) return;
              await Navigator.of(context).pushNamed("/HoldToLoad", arguments: {"ensureFirebaseInitialize" : true});
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                showSnackBarInformation(deviceHeight, deviceWidth, context,  "Email is Not Found",);
              } else if (e.code == 'wrong-password') {
                showSnackBarInformation(deviceHeight, deviceWidth, context,  "Password is Wrong",);
              }
            }
          }
        });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserCredential> _submitAuthForm(
      {required String email, required String password}) async {

    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  _hamMenuAndTitle(double deviceHeight) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: SizedBox(
              height:  deviceHeight / 6.6,
              child: TextButton(
                child: Icon(
                  Icons.keyboard_backspace,
                  color: const Color(0xFF2D9BF0),
                  size: deviceHeight / 6.6,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )),
        Expanded(
            flex: 10,
            child: Center(
              child: Text(
                "WashMe",
                style: GoogleFonts.fredokaOne(
                    fontSize: deviceHeight / 9, color: const Color(0xFF2D9BF0)),
              ),
            )),
        const Expanded(flex: 1, child: SizedBox())
      ],
    );
  }

  forgotPassword(double deviceHeight, double deviceWidth) {
    return Container(
      margin:
          EdgeInsets.only(top: deviceHeight / 60, bottom: deviceHeight / 30),
      child: Text(
        "Forgot your password?",
        style: GoogleFonts.openSans(
            fontSize: deviceWidth / 21,
            color: Colors.black,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  createAccount(double deviceWidth) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed("/RegisterPage");
      },
      child: Text(
        "Create an Account!",
        style: GoogleFonts.openSans(
            fontSize: deviceWidth / 21,
            color: Colors.black,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
