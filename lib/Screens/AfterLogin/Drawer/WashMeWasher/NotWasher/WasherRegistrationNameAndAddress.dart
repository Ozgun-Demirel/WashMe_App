import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../InterfaceFunc/registerWasher.dart';
import '../../../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';
import '../../../../../Validation/WasherRegistration/nameAndAddressValidator.dart';

class WasherRegistrationNameAndAddressFormData {
  String? name, middleName, surname, streetNumberAndName, city, state, zip;

  WasherRegistrationNameAndAddressFormData({
    this.name,
    this.middleName,
    this.surname,
    this.streetNumberAndName,
    this.city,
    this.state,
    this.zip,
  });

  toMap(){
    return {"name": name, "middleName": middleName, "surname": surname, "streetNumberAndName" : streetNumberAndName, "city": city, "state": state, "zip": zip!.toUpperCase()};
  }
}

class WasherRegistrationNameAndAddress extends StatefulWidget {
  static const routeName = "/WasherRegistrationNameAndAddress";
  const WasherRegistrationNameAndAddress({Key? key}) : super(key: key);

  @override
  State<WasherRegistrationNameAndAddress> createState() =>
      _WasherRegistrationNameAndAddressState();
}

class _WasherRegistrationNameAndAddressState
    extends State<WasherRegistrationNameAndAddress> with NameAndAddressValidatorMixin {
  final _washerInformationFormKey = GlobalKey<FormState>();
  WasherRegistrationNameAndAddressFormData washerRegisterFormData = WasherRegistrationNameAndAddressFormData();

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
              hamMenuAndTitle(_deviceHeight, _deviceWidth, context),
              SizedBox(
                height: _deviceHeight / 30,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Name & Address",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                ),
              ),
              SizedBox(
                height: _deviceHeight / 40,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Enter your name as it appears on your goverment  issued ID.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                ),
              ),
              SizedBox(
                height: _deviceHeight / 40,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Please note that once you enter your name, it CAN NOT BE CHANGED.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                ),
              ),
              washerInformationForm(_deviceHeight, _deviceWidth),
            ],
          ),
        ),
      )),
    );
  }

  hamMenuAndTitle(
      double deviceHeight, double deviceWidth, BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              child: TextButton(
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Color(0xFF2D9BF0),
                  size: deviceWidth / 12,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )),
        Expanded(
          flex: 16,
          child: Center(
            child: Text(
              "WashMe Washer",
              textAlign: TextAlign.center,
              style: GoogleFonts.fredokaOne(
                  fontSize: deviceWidth / 10, color: Color(0xFF2D9BF0)),
            ),
          ),
        )
      ],
    );
  }

  Widget washerInformationForm(double deviceHeight, double deviceWidth) {
    return Container(
      padding: EdgeInsets.all(deviceWidth / 40),
      child: Form(
        key: _washerInformationFormKey,
        child: Column(
          children: [
            SizedBox(
              height: deviceHeight / 80,
            ),
            nameField(),
            SizedBox(
              height: deviceHeight / 40,
            ),
            middleNameField(),
            SizedBox(
              height: deviceHeight / 40,
            ),
            lastNameField(),
            SizedBox(
              height: deviceHeight / 40,
            ),
            streetNumberAndNameField(),
            SizedBox(
              height: deviceHeight / 40,
            ),
            innerAddressFields(),
            SizedBox(
              height: deviceHeight / 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  _washerInformationFormKey.currentState?.save();

                  showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);

                  if (_washerInformationFormKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(duration: Duration(seconds: 3),content: Text('Processing Data')),
                    );
                    FirebaseAuth auth = FirebaseAuth.instance;
                    User? user = auth.currentUser;
                    DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore.instance.collection('users')
                        .doc(user!.uid)
                        .collection("washer")
                        .doc("washerInformations");
                    DocumentSnapshot<Map<String, dynamic>> querySnapshot = await documentRef.get();
                    Map<String, dynamic>? data = querySnapshot.data();

                      if (data!.containsKey("nameAndAddress")){
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(duration: Duration(seconds: 5),content: Text("You can not add new values here.")),
                        );
                      }
                      else {
                        data.addAll({"nameAndAddress" : washerRegisterFormData.toMap()});
                        documentRef.set(data);
                        var keys = data.keys;

                        if(!mounted) return;
                        registerWasher(data, keys, context, mounted);
                      }

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(duration: Duration(seconds: 2),content: Text('Photos are uploaded successfully')),
                    );
                    Navigator.of(context).pushReplacementNamed("/WasherRegistration");
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(duration: Duration(seconds: 4),content: Text('Your validation has failed.')),
                    );
                  }
                  },
                child: Container(child: Text("Done",
                    style: TextStyle( fontSize: deviceWidth / 20)), margin: EdgeInsets.only(right: deviceWidth/10, left: deviceWidth/10, top: deviceWidth/20, bottom: deviceWidth/20),)),
          ],
        ),
      ),
    );
  }

  nameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 4),
        ),
        filled: true,
        hintText: 'Sergio',
        labelText: 'Name',
        labelStyle: TextStyle(color: Colors.black),
      ),
      validator: (value) => nameValidator(value.toString()),
      onSaved: (String? value) {
        washerRegisterFormData.name = value.toString().trim();
      },
    );
  }

  Widget middleNameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4),
        ),
        filled: true,
        hintText: 'Domingo',
        labelText: 'Middle Name',
      ),
      validator: (value) => nameValidator(value.toString()),
      onSaved: (String? value) {
        washerRegisterFormData.middleName = value.toString().trim();
      },
    );
  }

  Widget lastNameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4),
        ),
        filled: true,
        hintText: 'Alvarez',
        labelText: 'Last Name',
      ),
      validator: (value) => nameValidator(value.toString()),
      onSaved: (String? value) {
        washerRegisterFormData.surname = value.toString().trim();
      },
    );
  }

  Widget streetNumberAndNameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 4),
        ),
        filled: true,
        hintText: '1352 Herendon Road Apt 104',
        labelText: 'Street Number and Name',
      ),
      validator: (value) => nameValidator(value.toString()),
      onSaved: (String? value) {
        washerRegisterFormData.streetNumberAndName = value.toString().trim();
      },
    );
  }

  Widget innerAddressFields() {
    return Row(
      children: [
        Expanded(
            flex: 10,
            child: TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 4),
                ),
                filled: true,
                hintText: 'Harlem',
                labelText: 'City',
              ),
              validator: (value) => nameValidator(value.toString()),
              onSaved: (String? value) {
                washerRegisterFormData.city = value.toString().trim();
              },
            )),
        Expanded(flex: 2, child: SizedBox()),
        Expanded(
            flex: 6,
            child: TextFormField(
              maxLength: 2,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 4),
                ),
                filled: true,
                hintText: 'NY',
                labelText: 'State',
                counterText: "",
              ),
              validator: (value) => stateValidator(value.toString()),
              onSaved: (String? value) {
                washerRegisterFormData.state = value.toString();
              },
            )),
        Expanded(flex: 2, child: SizedBox()),
        Expanded(
            flex: 8,
            child: TextFormField(
              maxLength: 5,
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 4),
                ),
                filled: true,
                hintText: '10417',
                labelText: 'ZIP',
                counterText: "",
              ),
              validator: (value) => zipValidator(value.toString()),
              onSaved: (String? value) {
                washerRegisterFormData.zip = value.toString();
              },
            )),
      ],
    );
  }
}
