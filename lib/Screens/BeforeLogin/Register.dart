import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';
import '../../InterfaceFunc/snackBarInformation.dart';
import '../../Validation/LoginRegisterValidations/RegisterValidator.dart';
import '../SplashAndIntro/Splash.dart';

bool _passwordVisible = true;

class FormData {
  String? email;
  String? password;
  String? rePassword;

  FormData({
    this.email,
    this.password,
    this.rePassword,
  });
}

class RegisterPage extends StatefulWidget {
  static const routeName = "/RegisterPage";
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State with RegisterValidationMixin {
  final _registerFormKey = GlobalKey<FormState>();
  FormData registerFormData = FormData();

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
                  height: _deviceHeight / 20,
                ),
                Image.asset(
                  "lib/Assets/WashMe/BeforeLogin/Register/user.png",
                  height: _deviceHeight / 5,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(_deviceWidth / 16),
                  child: Form(
                    key: _registerFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        EmailTaker(),
                        SizedBox(
                          height: 10,
                        ),
                        PasswordTaker(),
                        SizedBox(
                          height: 10,
                        ),
                        PasswordChecker(),
                        SizedBox(
                          height: 20,
                        ),
                        buildRegisterButton(_deviceHeight, _deviceWidth),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget EmailTaker() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress, //@
      textInputAction: TextInputAction.next,
      validator: (value) => validateEmail(value.toString()),
      decoration: const InputDecoration(
        fillColor: Colors.white,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4),
        ),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: Colors.black,
        ),
        filled: true,
        hintText: 'info@roadeo.com',
        labelText: 'Email',
      ),
      onSaved: (String? value) {
        registerFormData.email = value.toString();
      },
    );
  }

  Widget PasswordTaker() {
    return TextFormField(
      obscureText: _passwordVisible,
      textInputAction: TextInputAction.next,
      validator: (value) => validatePassword(value.toString()),
      decoration: InputDecoration(
        fillColor: Colors.white,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4),
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.black,
        ),
        filled: true,
        hintText: 'Abc1234',
        labelText: 'Password',
        suffixIcon: IconButton(
          color: Colors.black,
          icon: Icon(
            // Based on passwordVisible state choose the icon
            !_passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          isEnabled = true;
        });
        registerFormData.password = value.toString();
      },
    );
  }

  bool isEnabled = false;
  Widget PasswordChecker() {
    return TextFormField(
      obscureText: _passwordVisible,
      enabled: isEnabled,
      validator: (value) => validateRePassword(
          password: registerFormData.password, rePassword: value.toString()),
      decoration: InputDecoration(
        fillColor: Colors.white,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4),
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.black,
        ),
        filled: true,
        hintText: 'Abc1234',
        labelText: 'Retype Password',
        suffixIcon: IconButton(
          color: Colors.black,
          icon: Icon(
            // Based on passwordVisible state choose the icon
            !_passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      onSaved: (String? value) {
        registerFormData.rePassword = value.toString();
      },
    );
  }

  Widget buildRegisterButton(double deviceHeight, double deviceWidth) {
    return ElevatedButton(
      child: Container(
          margin: EdgeInsets.only(
              top: deviceHeight / 42,
              bottom: deviceHeight / 42,
              left: deviceWidth / 5,
              right: deviceWidth / 5),
          child: Text("Register", style: GoogleFonts.notoSans(
          fontSize: deviceWidth / 24,
          ),)),
      onPressed: () async {

        showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);

        FocusScope.of(context).unfocus();
        _registerFormKey.currentState?.save();
        if (_registerFormKey.currentState!.validate()) {
          // If the form is valid, display a snack bar. In the real world,
          // you'd often call a server or save the information in a database.

          showSnackBarInformation(deviceHeight, deviceWidth, context, 'Trying to register');

          _submitAuthForm(
            email: registerFormData.email.toString().trim(),
            password: registerFormData.password.toString().trim(),
            deviceHeight: deviceHeight,
            deviceWidth: deviceWidth
          );
        }
      },
    );
  }

  Future<void> _submitAuthForm(
      {
      required String email,
      required String password,
        required double deviceHeight, required double deviceWidth, }) async {
    try {

      var auth = FirebaseAuth.instance;
      final User? anonymousUser = auth.currentUser;

      QuerySnapshot<Map<String, dynamic>> locationsCollection = await FirebaseFirestore.instance
          .collection('users')
          .doc(anonymousUser!.uid).collection("locations").get();

      DocumentSnapshot<Map<String, dynamic>> currentOrdersCollection = await FirebaseFirestore.instance.collection("users").doc(anonymousUser.uid).collection("currentOrders").doc("washMe").get();

      try {
        if (anonymousUser.isAnonymous){
          await anonymousUser.updateEmail(email);
          await anonymousUser.updatePassword(password);
        }
      } catch (err){
        if(!mounted) return;
        Navigator.of(context).pop();
        showSnackBarInformation(deviceHeight, deviceWidth, context, err.toString());
        return;
      }

      User? newUser = FirebaseAuth.instance.currentUser;


      if (locationsCollection.docs.isNotEmpty){
        for (int index = 0; index< locationsCollection.docs.length ; index++){
          await FirebaseFirestore.instance
              .collection('users')
              .doc(newUser!.uid).collection("locations").doc(locationsCollection.docs[index].id).set(locationsCollection.docs[index].data());
        }
      } else {
        print("it is empty");
      }

      if (currentOrdersCollection.exists && currentOrdersCollection.data() != null){
        var currentOrderMap = currentOrdersCollection.data();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(newUser!.uid).collection("currentOrders").doc("washMe").set(currentOrderMap!);
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser!.uid)
          .set({
        'email': email,
        'washer': false,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? _showIntro = prefs.getBool("showIntro");

      if(!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Splash(showIntro: _showIntro)), (route) => false);

    } on FirebaseAuthException catch (err) {
      if (err.code == 'email-already-in-use') {

        showSnackBarInformation(deviceHeight, deviceWidth, context, "Email is already in use.");

      }
    } catch (err) {
      showSnackBarInformation(deviceHeight, deviceWidth, context, err.toString());
    }
  }

  _hamMenuAndTitle(double deviceHeight) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: TextButton(
              child: Icon(
                Icons.keyboard_backspace,
                color: Color(0xFF2D9BF0),
                size: deviceHeight / 6.6,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        Expanded(
            flex: 10,
            child: Center(
              child: Text(
                "WashMe",
                style: GoogleFonts.fredokaOne(
                    fontSize: deviceHeight / 9, color: Color(0xFF2D9BF0)),
              ),
            )),
        Expanded(flex: 1, child: SizedBox())
      ],
    );
  }


}
