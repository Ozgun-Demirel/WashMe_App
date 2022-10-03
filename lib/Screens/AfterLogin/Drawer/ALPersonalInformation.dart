import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../InterfaceFunc/screenOpeners/CustomerSide/PersonalInformation/myInformationsOpener.dart';
import '../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';
import '../../SplashAndIntro/Splash.dart';

class ALPersonalInformation extends StatefulWidget {
  static const routeName = "/ALPersonalInformation";
  const ALPersonalInformation({Key? key}) : super(key: key);

  @override
  State<ALPersonalInformation> createState() => _ALPersonalInformationState();
}

class _ALPersonalInformationState extends State<ALPersonalInformation> {
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
                hamMenuAndTitle(_deviceWidth, context),
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Personal Information",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
                  ),
                ),
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                Image.asset(
                  "lib/Assets/WashMe/account.png",
                  height: _deviceWidth / 4,
                ),
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF2D9BF0),
                    ),
                    onPressed: () {
                      myInformationsOpener(context, _deviceHeight, _deviceWidth, mounted, false);
                    },
                    child: SizedBox(
                        height: _deviceHeight / 12,
                        width: _deviceWidth * (5 / 8),
                        child: Center(
                            child: Text("My Information",
                                style: TextStyle(fontSize: _deviceWidth / 21))))),
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF2D9BF0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/MyCars");

                    },
                    child: SizedBox(
                        height: _deviceHeight / 12,
                        width: _deviceWidth * (5 / 8),
                        child: Center(
                            child: Text("My Cars",
                                style: TextStyle(fontSize: _deviceWidth / 21))))),
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF2D9BF0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/MyAddresses");

                    },
                    child: SizedBox(
                        height: _deviceHeight / 12,
                        width: _deviceWidth * (5 / 8),
                        child: Center(
                            child: Text("My Addresses",
                                style: TextStyle(fontSize: _deviceWidth / 21))))),
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF2D9BF0),
                    ),
                    onPressed: () {
                      null;
                    },
                    child: SizedBox(
                        height: _deviceHeight / 12,
                        width: _deviceWidth * (5 / 8),
                        child: Center(
                            child: Text("Payment Methods",
                                style: TextStyle(fontSize: _deviceWidth / 21))))),
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                ElevatedButton(
                    onPressed: () async {

                      showTransparentDialogOnLoad(context, _deviceHeight, _deviceWidth);

                      FirebaseAuth.instance.signOut();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      bool? _showIntro = prefs.getBool("showIntro");

                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Splash(showIntro: _showIntro)), (route) => false);

                    },
                    child: SizedBox(
                        height: _deviceHeight / 12,
                        width: _deviceWidth * (5 / 8),
                        child: Center(
                            child: Text("Logout",
                                style: TextStyle(fontSize: _deviceWidth / 21))))),
              ],
            ),
          ),
        ));
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
}
