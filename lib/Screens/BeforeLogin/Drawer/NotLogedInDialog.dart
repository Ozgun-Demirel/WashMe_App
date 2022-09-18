import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../LoginPage.dart';

Widget notLoggedInDialog(double deviceHeight, double deviceWidth, BuildContext context, {String displayText = "Please log in first to reach this page."}) {
  return SimpleDialog(
    insetPadding: EdgeInsets.all(deviceWidth / 40),
    children: [
      Container(
        width: deviceWidth * (11 / 12),
        padding: EdgeInsets.all(deviceWidth / 20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                "You are not logged in.",
                style: GoogleFonts.openSans(fontSize: deviceWidth / 20),
              ),
            ),
            SizedBox(
              height: deviceHeight / 45,
            ),
            Container(
              width: double.infinity,
              child: Text(
                displayText,
                style: GoogleFonts.openSans(fontSize: deviceWidth / 20),
              ),
            ),
            SizedBox(
              height: deviceHeight / 45,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Container(
                padding: EdgeInsets.all(deviceWidth/40),
                child: Text(
                  "Login",
                  style: GoogleFonts.openSans(fontSize: deviceWidth / 20),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
