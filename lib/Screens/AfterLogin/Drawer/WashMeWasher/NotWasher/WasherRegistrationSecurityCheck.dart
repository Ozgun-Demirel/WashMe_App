import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../InterfaceFunc/registerWasher.dart';
import '../../../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';

class WasherRegistrationSecurityCheck extends StatefulWidget {
  static const routeName = "/WasherRegistrationSecurityCheck";
  const WasherRegistrationSecurityCheck({Key? key}) : super(key: key);

  @override
  State<WasherRegistrationSecurityCheck> createState() => _WasherRegistrationSecurityCheckState();
}

class _WasherRegistrationSecurityCheckState extends State<WasherRegistrationSecurityCheck> {
  bool sendCopy = false;
  String? SSN;
  @override
  Widget build(BuildContext context) {

    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;


    return Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            } // When not focused to Form TextFormFields',
            // keyboard will be lost automatically.
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(_deviceWidth/45),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: _deviceHeight/45,),
                  hamMenuAndTitle(_deviceHeight, _deviceWidth, context),
                  SizedBox(
                    height: _deviceHeight / 30,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Background Check",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
                    ),
                  ),
                  SizedBox(
                    height: _deviceHeight / 60,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(right: _deviceWidth/40),
                    child: Text(
                      "In order to work on the WashMe platform, you must undergo a background check.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                    ),
                  ),
                  SizedBox(
                    height: _deviceHeight / 30,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(right: _deviceWidth/40),
                    child: Text(
                      "Bizim Şemsiye Şirket and its subsidiaries diyerek buraya disclaimer gelecek. Falan filan, lorem ipsum, filan falan, ipsum lorem.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                    ),
                  ),
                  SizedBox(
                    height: _deviceHeight / 60,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        side: MaterialStateBorderSide.resolveWith(
                              (_) => BorderSide(width: 2.0, color: Colors.black),
                        ),
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.all(Color(0xFF2D9BF0)),
                        value: sendCopy,
                        onChanged: (bool? value) {
                          sendCopy = !sendCopy;
                          setState((){});
                        },
                      ),
                      TextButton(onPressed: (){
                        sendCopy = !sendCopy;
                        setState((){});
                      }, child: Text("Recieve a copy of your background check",
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold, fontSize: _deviceWidth / 28),),)
                    ],
                  ),
                  SizedBox(
                    height: _deviceHeight / 60,
                  ),
                  Container(
                    child: Center(child: Text("Social Security Number",
                      style: GoogleFonts.openSans( fontSize: _deviceWidth / 16),)),
                  ),
                  SizedBox(
                    height: _deviceHeight / 100,
                  ),
                  SizedBox(
                    width: _deviceWidth/2,
                    child: Center(child: TextField(
                      maxLength: 8,
                      textAlign: TextAlign. center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 4),
                        ),
                        filled: true,
                        hintText: '11100111',
                      ),
                      onChanged: (String? value) {
                        SSN = value.toString().trim();
                      },
                    ),
                    ),
                  ),
                  SizedBox(
                    height: _deviceHeight / 40,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(right: _deviceWidth/40),
                    child: Text(
                      "SSN is needed to run background check and for us to pay you for your service.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                    ),
                  ),
                  SizedBox(
                    height: _deviceHeight / 80,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(right: _deviceWidth/40),
                    child: Text(
                      "No credit check is run.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(right: _deviceWidth/40),
                    child: Text.rich(
                      TextSpan(
                        text: 'Your credit  ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'is not affected.',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              )),
                          // can add more TextSpans here...
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: _deviceHeight/40,),
                  Container(
                    child: ElevatedButton(
                        onPressed: () async {

                          FocusScope.of(context).unfocus();

                          showTransparentDialogOnLoad(context, _deviceHeight, _deviceWidth);

                          FirebaseAuth auth = FirebaseAuth.instance;
                          User? user = auth.currentUser;
                          DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore.instance.collection('users')
                              .doc(user!.uid)
                              .collection("washer")
                              .doc("washerInformations");
                          DocumentSnapshot<Map<String, dynamic>> querySnapshot = await documentRef.get();
                          Map<String, dynamic>? data = querySnapshot.data();
                          if (SSN == null || SSN!.length <8){
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(duration: Duration(seconds: 5),content: Text("Enter a valid Social Security Number.")),);

                            return;
                          }

                            if (data!.containsKey("SSN")){
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(duration: Duration(seconds: 5),content: Text("You can not add new values here.")),);
                              return;
                            }
                            else {
                              data.addAll({"SSN" : SSN});
                              documentRef.set(data);
                              var keys = data.keys;

                              if(!mounted) return;
                              registerWasher(data, keys, context, mounted);
                            }

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(duration: Duration(seconds: 5),content: Text("Your information has been saved successfully.")),);
                          Navigator.of(context).pushReplacementNamed("/WasherRegistration");
                        },
                        child: Container(margin: EdgeInsets.only(right: _deviceWidth/10, left: _deviceWidth/10, top: _deviceWidth/20, bottom: _deviceWidth/20),child: Text("I agree and acknowledge",
                            style: TextStyle( fontSize: _deviceWidth / 20)),)),
                  ),
                ],
              ),
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
}
