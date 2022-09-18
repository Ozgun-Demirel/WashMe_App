
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BecomeWasher extends StatefulWidget {
  static const routeName = "/BecomeWasher";
  const BecomeWasher({Key? key}) : super(key: key);

  @override
  State<BecomeWasher> createState() => _BecomeWasherState();
}

class _BecomeWasherState extends State<BecomeWasher> {


  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
            becomeAWasher(
              _deviceWidth,
            ),
            SizedBox(
              height: _deviceHeight / 20,
            ),
            Text(
              "Log into Your Washer Account!",
              style: GoogleFonts.fredokaOne(fontSize: _deviceWidth / 12),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: _deviceHeight / 20,
            ),
            ElevatedButton(
                onPressed: () async {

                  FirebaseAuth auth = FirebaseAuth.instance;
                  User? user = auth.currentUser;


                  DocumentSnapshot<Map<String, dynamic>> washerCol = await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection("washer").doc("washerInformations").get() ;

                  var washerData = washerCol.data() ;

                  DocumentReference<Map<String, dynamic>> uniqueID;
                  if (washerData != null && washerData.containsKey("washerID")){

                    washerData.update("washerID", (value) => FieldValue.delete());
                    uniqueID = await FirebaseFirestore.instance.collection('washerInformations').add({"nameAndAddress" : "false"});

                  } else {
                    uniqueID = await FirebaseFirestore.instance.collection(
                        'washerInformations').add({"nameAndAddress": "false"});
                  }

                    DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore.instance.collection('users')
                        .doc(user.uid)
                        .collection("washer")
                        .doc("washerInformations");
                    documentRef.set({"washerID" : uniqueID.id});



                  if (!mounted) return;
                  Navigator.of(context).pushNamed("/WasherRegistration");
                },
                child: Container(
                    width: _deviceWidth * (3 / 4),
                    height: _deviceHeight / 14,
                    child: Center(
                        child: Text(
                      "Register as a Washer",
                      style: GoogleFonts.openSans(fontSize: _deviceWidth / 20),
                      textAlign: TextAlign.center,
                    )))),
            SizedBox(
              height: _deviceHeight / 80,
            ),
            Container(
              child: Center(
                  child: Text(
                "OR",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, fontSize: _deviceWidth / 24),
              )),
            ),
            SizedBox(
              height: _deviceHeight / 80,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/ContinueWithoutRegistration");
                },
                child: Container(
                  width: _deviceWidth * (3 / 4),
                  height: _deviceHeight / 14,
                  child: Center(
                    child: Text(
                      "Continue Without Registration",
                      style: GoogleFonts.openSans(fontSize: _deviceWidth / 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          ],
        ),
      ),
    ));
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
                  size: deviceHeight / 16,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("/ALClientInputs");
                },
              ),
            )),
        Expanded(
          flex: 12,
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

  Widget becomeAWasher(double deviceWidth) {
    return Container(
        padding: EdgeInsets.all(deviceWidth / 30),
        child: Column(
          children: [
            Text(
              "Become",
              style: GoogleFonts.fredokaOne(
                  color: Color(0xFF414BB2), fontSize: deviceWidth / 9),
              textAlign: TextAlign.center,
            ),
            Text(
              "a Washer",
              style: GoogleFonts.fredokaOne(
                  color: Color(0xFF414BB2), fontSize: deviceWidth / 9),
              textAlign: TextAlign.center,
            ),
            Text(
              "and make",
              style: GoogleFonts.fredokaOne(
                  color: Color(0xFF414BB2), fontSize: deviceWidth / 9),
              textAlign: TextAlign.center,
            ),
            Text(
              "\$2,200 - \$3,100",
              style: GoogleFonts.fredokaOne(
                  color: Color(0xFF414BB2), fontSize: deviceWidth / 9),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }


}
