import 'dart:io';

import 'package:WashMe/InterfaceFunc/ImageHelper/imagePicker.dart';
import 'package:WashMe/InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../FirebaseHelper/FirestoreHelpers/UserHelpers/UserInformationsHelper.dart';
import '../../../../InterfaceFunc/DatabaseHelpers/SubHelpers/userMyInformationHelper.dart';
import '../../../../InterfaceFunc/screenOpeners/CustomerSide/PersonalInformation/myInformationsOpener.dart';
import '../../../../Models/Users/userInformations.dart';
import '../../../../Validation/Customer/myInformationsValidator.dart';

class MyInformation extends StatefulWidget {
  static const routeName = "/MyInformation";
  const MyInformation({Key? key}) : super(key: key);

  @override
  State<MyInformation> createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation>
    with MyInformationsValidationMixin {
  final _myInformationFormKey = GlobalKey<FormState>();
  final _addedInformationFormData = UserInformations();

  @override
  Widget build(BuildContext context) {
    final Map<String, UserInformations?> arguments =
        (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{})
            as Map<String, UserInformations?>;
    UserInformations? userInformations = arguments["userInformations"];

    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _myInformationMainPage(
          _deviceHeight, _deviceWidth, context, userInformations),
    );
  }

  hamMenuAndTitle(double deviceHeight, BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: SizedBox(
              height: deviceHeight / 6.6,
              child: TextButton(
                child: Icon(
                  Icons.keyboard_backspace,
                  color: const Color(0xFF2D9BF0),
                  size: deviceHeight / 6.6,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
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

  Widget myInformationForm(double deviceHeight, double deviceWidth,
      UserInformations? userInformations) {
    return Form(
      key: _myInformationFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (value) => validateFullName(value.toString()),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 4),
              ),
              filled: true,
              labelText:
                  userInformations == null || userInformations.fullName == null
                      ? "Full Name"
                      : userInformations.fullName,
            ),
            onSaved: (String? value) {
              _addedInformationFormData.fullName = value;
            },
          ),
          SizedBox(height: deviceHeight / 40),
          TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (value) => validateSurname(value.toString()),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 4),
              ),
              filled: true,
              labelText:
                  userInformations == null || userInformations.surname == null
                      ? "Surname"
                      : userInformations.surname,
            ),
            onSaved: (String? value) {
              _addedInformationFormData.surname = value;
            },
          ),
          SizedBox(height: deviceHeight / 40),
          TextFormField(
            maxLength: 10,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (value) => validatePhoneNumber(value.toString()),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 4),
              ),
              filled: true,
              labelText: userInformations == null ||
                      userInformations.phoneNumber == null
                  ? "Phone Number"
                  : userInformations.phoneNumber,
            ),
            onSaved: (String? value) {
              _addedInformationFormData.phoneNumber = value;
            },
          ),
          SizedBox(height: deviceHeight / 40),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => validateEmail(value.toString()),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 4),
              ),
              filled: true,
              labelText: userInformations == null ||
                      userInformations.contactEmail == null
                  ? "E-mail"
                  : userInformations.contactEmail,
            ),
            onSaved: (String? value) {
              _addedInformationFormData.contactEmail = value;
            },
          ),
          SizedBox(height: deviceHeight / 40),
          TextFormField(
            enabled: false,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 4),
              ),
              filled: true,
              labelText: "Password",
            ),
            onSaved: (String? value) {
              //registerFormData.email = value.toString();
            },
          ),
        ],
      ),
    );
  }

  Widget _myInformationMainPage(double deviceHeight, double deviceWidth,
      BuildContext context, UserInformations? userInformations) {

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(deviceWidth / 45),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: deviceHeight / 45,
            ),
            hamMenuAndTitle(deviceWidth, context),
            SizedBox(
              height: deviceHeight / 30,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                "My Information",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: deviceWidth / 21),
              ),
            ),
            SizedBox(
              height: deviceHeight / 30,
            ),
            userInformations!.photoFilePath == null
                ? TextButton(
                    onPressed: () async {
                      await selectPicture(userInformations);
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: deviceWidth / 4,
                          width: deviceWidth / 4,
                          child: Center(
                            child: Image.asset(
                              "lib/Assets/WashMe/camera.png",
                              height: deviceWidth / 8,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: deviceWidth / 4,
                          width: deviceWidth / 4,
                          child: Image.asset(
                            "lib/Assets/WashMe/account.png",
                            color: Colors.black.withOpacity(0.5),
                            height: deviceWidth / 4,
                          ),
                        ),
                      ],
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      await selectPicture(userInformations);
                    },
                    child: SizedBox(
                        width: deviceWidth / 4,
                        child: Image.file(
                          File(userInformations.photoFilePath!),
                        ))),
            Container(
                padding: EdgeInsets.all(deviceWidth / 20),
                child: myInformationForm(
                    deviceHeight, deviceWidth, userInformations)),
            SizedBox(
              height: deviceHeight / 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  showTransparentDialogOnLoad(
                      context, deviceHeight, deviceWidth);

                  _myInformationFormKey.currentState?.save();

                  if (_myInformationFormKey.currentState!.validate()) {
                    if (_addedInformationFormData.photoFilePath != null) {
                      _addedInformationFormData.id =
                          FirebaseAuth.instance.currentUser!.uid;
                      InformationHelper.insertInformation(
                          _addedInformationFormData.toMap());
                      await FirestoreUserInformationsHelper
                          .userInformationsAdder(_addedInformationFormData);

                      if (!mounted) return;
                      Navigator.of(context).pop();
                      myInformationsOpener(
                          context, deviceHeight, deviceWidth, mounted, true);
                    }
                  } else {
                    Navigator.of(context).pop();
                  }


                },
                child: Container(
                  padding: EdgeInsets.only(
                      left: deviceWidth / 6,
                      right: deviceWidth / 6,
                      top: deviceWidth / 20,
                      bottom: deviceWidth / 20),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: deviceWidth / 21),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> selectPicture(UserInformations userInformations) async {
    _addedInformationFormData.photoFilePath =
        (await ImagePickerHelper.selectPicture())?.path;
    userInformations.photoFilePath = _addedInformationFormData.photoFilePath;
    setState(() {});
  }
}
