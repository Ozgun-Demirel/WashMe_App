import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

Widget ReferAFriend(double deviceHeight, double deviceWidth, BuildContext context,) {
  return SimpleDialog(
    insetPadding: EdgeInsets.all(deviceWidth / 40),
    children: [
      SizedBox(
        width: deviceWidth * (11 / 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.only(left: deviceWidth / 30),
                    child: Text(
                      "Refer a Friend",
                      style: GoogleFonts.notoSans(
                          fontSize: deviceWidth / 21,
                          fontWeight: FontWeight.bold),
                    )),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                      icon: const Icon(Icons.close)),
                ),
              ],
            ),
            SizedBox(
              height: deviceHeight / 45,
            ),
            Image.asset(
              "lib/Assets/WashMe/CommonScreens/sharing.png",
              height: deviceHeight / 5,
            ),
            SizedBox(
              height: deviceHeight / 45,
            ),
            Text(
              "Take a minute to share us via",
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold, fontSize: deviceWidth / 21),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight/40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: "t.washme.com/app"));
                  },
                  child: Text(
                    "t.washme.com/app",
                    style: GoogleFonts.openSans (
                        fontWeight: FontWeight.bold, fontSize: deviceWidth / 21),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(onPressed: () {Clipboard.setData(const ClipboardData(text: "t.washme.com/app"));},
                icon: FaIcon(FontAwesomeIcons.copy, size: deviceWidth/12)),
              ],
            ),
            SizedBox(height: deviceHeight/40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "lib/Assets/WashMe/CommonScreens/whatsapp.png",
                    height: deviceHeight / 12,
                  ),
                  Image.asset(
                    "lib/Assets/WashMe/CommonScreens/facebook.png",
                    height: deviceHeight / 12,
                  ),
                  Image.asset(
                    "lib/Assets/WashMe/CommonScreens/twitter.png",
                    height: deviceHeight / 12,
                  ),
                  Image.asset(
                    "lib/Assets/WashMe/CommonScreens/instagram.png",
                    height: deviceHeight / 12,
                  ),
                ],
            ),
          ],
        ),
      ),
    ],
  );
}
