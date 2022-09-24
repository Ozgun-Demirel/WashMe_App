import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../FirebaseHelper/FirestoreHelpers/UserHelpers/UserInformationsHelper.dart';
import '../../../../InterfaceFunc/DatabaseHelpers/SubHelpers/userMyInformationHelper.dart';
import '../../../../Models/Users/userInformations.dart';

class MyInformation extends StatefulWidget {
  static const routeName = "/MyInformation";
  const MyInformation({Key? key}) : super(key: key);

  @override
  State<MyInformation> createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  final _myInformationFormKey = GlobalKey<FormState>();
  var _myInformationFormData = UserInformations();
  final _addedInformationFormData = UserInformations();

  var futureBuilderFuture;

  @override
  initState(){
    super.initState();
    futureBuilderFuture =  getMyInformations();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder(
        future: futureBuilderFuture,
        builder: (BuildContext ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _myInformationMainPage(_deviceHeight, _deviceWidth, ctx);
              }
          }
        },
      )


    );
  }

  getMyInformations() async {
    user = _auth.currentUser;
    var informationData = await InformationHelper.getInformationsData();
    if (informationData.isNotEmpty) {
      _myInformationFormData = UserInformations.fromMap(informationData[0]);
    }
    if (user != null) {
      DocumentReference<Map<String, dynamic>> documentRef =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await documentRef.get();
      _myInformationFormData =
          UserInformations.fromMap(querySnapshot.data() as Map<String, dynamic>);
    }
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

  Widget myInformationForm(double deviceHeight, double deviceWidth) {
    return Form(
      key: _myInformationFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 4),
              ),
              filled: true,
              labelText: _myInformationFormData.fullName ?? "Full Name",
            ),
            onSaved: (String? value) {
              _addedInformationFormData.fullName = value;
            },
          ),
          SizedBox(height: deviceHeight/40),
          TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 4),
              ),
              filled: true,
              labelText: _myInformationFormData.surname ?? "Surname",
            ),
            onSaved: (String? value) {
              _addedInformationFormData.surname = value;
            },
          ),
          SizedBox(height: deviceHeight/40),
          TextFormField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 4),
              ),
              filled: true,
              labelText: _myInformationFormData.phoneNumber ?? "Phone Number",
            ),
            onSaved: (String? value) {
              _addedInformationFormData.phoneNumber = value;
            },
          ),
          SizedBox(height: deviceHeight/40),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.white,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 4),
              ),
              filled: true,
              labelText: _myInformationFormData.contactEmail ?? "E-mail",
            ),
            onSaved: (String? value) {
              _addedInformationFormData.contactEmail = value;
            },
          ),
          SizedBox(height: deviceHeight/40),
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

  Widget _myInformationMainPage(double deviceHeight, double deviceWidth, BuildContext context) {
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
            Image.asset(
              "lib/Assets/WashMe/account.png",
              height: deviceWidth / 4,
            ),
            Container(
                padding: EdgeInsets.all(deviceWidth / 20),
                child: myInformationForm(deviceHeight, deviceWidth)),
            SizedBox(
              height: deviceHeight / 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  _myInformationFormKey.currentState?.save();
                  if (user != null) {
                    _addedInformationFormData.id = user!.uid;
                    try {
                      InformationHelper.insertInformation(
                          _addedInformationFormData.toMap());
                      return FirestoreUserInformationsHelper
                          .userInformationsAdder(_myInformationFormData, _addedInformationFormData);
                    } catch (error) {
                      print(error);
                    }
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
}
