import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WasherRegistration extends StatefulWidget {
  static const routeName = "/WasherRegistration";
  const WasherRegistration({Key? key}) : super(key: key);

  @override
  State<WasherRegistration> createState() => _WasherRegistrationState();
}

class _WasherRegistrationState extends State<WasherRegistration> {

  Map<String, bool> _washerInformationsMap = {};

  @override
  initState()  {
    getPendingInformations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(_deviceWidth/45),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: _deviceHeight/45,),
                hamMenuAndTitle(_deviceHeight, _deviceWidth, context),
                SizedBox(height: _deviceHeight/40,),
                Text("You need to proived required informations below to be a WashMe Washer!",
                  style: GoogleFonts.openSans(fontSize: _deviceWidth / 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                SizedBox(
                  height: _deviceHeight/32,
                ),
                Image.asset(
                  "lib/Assets/WashMe/account.png",
                  height: _deviceWidth / 3,
                ),
                SizedBox(
                  height: _deviceHeight/40,
                ),
                buttonsBuilder(_deviceHeight, _deviceWidth, context),
              ],
            ),
          ),
        )
    );
  }

  hamMenuAndTitle(double deviceHeight, double deviceWidth, BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: TextButton(
              child: Icon(
                Icons.keyboard_backspace,
                color: const Color(0xFF2D9BF0),
                size: deviceHeight / 16,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        Expanded(
          flex: 12,
          child: Center(
            child: Text(
              "WashMe Washer",
              textAlign: TextAlign.center,
              style: GoogleFonts.fredokaOne(
                  fontSize: deviceWidth / 10, color: const Color(0xFF2D9BF0)),
            ),
          ),
        )
      ],
    );
  }

  Widget buttonsBuilder(double deviceHeight, double deviceWidth, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(deviceWidth/24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 12,child: ElevatedButton(onPressed: (){
                if ( _washerInformationsMap.isNotEmpty && _washerInformationsMap["nameAndAddress"] == true){
                  return;
                } else {
                  Navigator.of(context).pushNamed("/WasherRegistrationNameAndAddress");
                }
              },
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                  child: SizedBox(
                    height: deviceHeight / 14,
                child: Center(child: Text("Name & Address ${_washerInformationsMap.isNotEmpty && _washerInformationsMap["nameAndAddress"] == true ? "   (Pending)" : "   (Required)"}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                      fontWeight: _washerInformationsMap.isNotEmpty && _washerInformationsMap["nameAndAddress"] == true ? null : FontWeight.bold,
                      fontSize: deviceWidth / 20),)),
              )),),
            ],
          ),
          SizedBox(height: deviceHeight/30,),
          Row(
            children: [
              Expanded(flex: 12,child: ElevatedButton(onPressed: (){
                if ( _washerInformationsMap.isNotEmpty && _washerInformationsMap["photosURL"] == true){
                  return;
                } else {
                  Navigator.of(context).pushNamed("/WasherRegistrationPhotos");
                }
              },
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                  child: SizedBox(
                    height: deviceHeight / 14,
                    child: Center(child: Text("Photos ${_washerInformationsMap.isNotEmpty && _washerInformationsMap["photosURL"] == true ? "   (Pending)" : "   (Required)"}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                          fontWeight: _washerInformationsMap.isNotEmpty && _washerInformationsMap["photosURL"] == true ? null : FontWeight.bold,
                          fontSize: deviceWidth / 20),)),
                  )),),
            ],
          ),
          SizedBox(height: deviceHeight/30,),
          Row(
            children: [
              Expanded(flex: 12,child: ElevatedButton(onPressed: (){
                if ( _washerInformationsMap.isNotEmpty && _washerInformationsMap["IDURL"] == true){
                  return;
                } else {

                  Navigator.of(context).pushNamed("/WasherRegistrationID");
                }
              },
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                  child: SizedBox(
                    height: deviceHeight / 14,
                    child: Center(child: Text("ID ${_washerInformationsMap.isNotEmpty && _washerInformationsMap["IDURL"] == true ? "   (Pending)" : "   (Required)"}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                          fontWeight: _washerInformationsMap.isNotEmpty && _washerInformationsMap["IDURL"] == true ? null : FontWeight.bold,
                          fontSize: deviceWidth / 20),)),
                  )),),
            ],
          ),
          SizedBox(height: deviceHeight/30,),
          Row(
            children: [
              Expanded(flex: 12,child: ElevatedButton(onPressed: (){
                if ( _washerInformationsMap.isNotEmpty && _washerInformationsMap["SSN"] == true){
                  return;
                } else {
                  Navigator.of(context).pushNamed("/WasherRegistrationSecurityCheck");
                }

              },
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                  child: SizedBox(
                    height: deviceHeight / 14,
                    child: Center(child: Text("Security Check ${_washerInformationsMap.isNotEmpty && _washerInformationsMap["SSN"] == true ? "   (Pending)" : "   (Required)"}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                          fontWeight: _washerInformationsMap.isNotEmpty && _washerInformationsMap["SSN"] == true ? null : FontWeight.bold,
                          fontSize: deviceWidth / 20),)),
                  )),),
            ],
          ),

        ],
      ),
    );
  }

  getPendingInformations() async {
    var auth = FirebaseAuth.instance;

    var user = auth.currentUser;

    DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore
        .instance
        .collection('users')
        .doc(user!.uid)
        .collection("washer")
        .doc("washerInformations");
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
    await documentRef.get();
    Map<String, dynamic>? data = querySnapshot.data();
    Map<String, bool> washerInformationsMap = {};
    if (data != null) {
      if (data.containsKey("photosURL")) {
        washerInformationsMap["photosURL"] = true;
      }

      if (data.containsKey("SSN")) {
        washerInformationsMap["SSN"] = true;
      }

      if (data.containsKey("nameAndAddress")) {
        washerInformationsMap["nameAndAddress"] = true;
      }

      if (data.containsKey("IDURL")) {
        washerInformationsMap["IDURL"] = true;
      }
    } else {
      print("data is totally Null");
    }

    setState(() {
      _washerInformationsMap = washerInformationsMap;
    });
  }
}
