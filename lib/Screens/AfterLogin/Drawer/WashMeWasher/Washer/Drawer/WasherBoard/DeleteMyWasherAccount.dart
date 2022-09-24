import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../../FirebaseHelper/StorageHelper/StorageHelper.dart';
import '../../../../../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';
import '../../../../../../SplashAndIntro/Splash.dart';

class DeleteMyWasherAccount extends StatefulWidget {
  static const routeName = "/DeleteMyWasherAccount";
  const DeleteMyWasherAccount({Key? key}) : super(key: key);

  @override
  State<DeleteMyWasherAccount> createState() => _DeleteMyWasherAccountState();
}

class _DeleteMyWasherAccountState extends State<DeleteMyWasherAccount> {
  List<String> rateUs1Answers = [
    "I experience bugs and errors in the app.",
    "I don't like the WashMe system.",
    "I don't want to wash car anymore.",
    "I can't reach the clients from the system.",
    "Other (Please specify here.)"
  ];
  String rateUs1Answer = "I experience bugs and errors in the app.";
  double rateUs2Answer = 3;
  double rateUs3Answer = 3;

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
                  "Delete My Washer Account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
                ),
              ),
              SizedBox(
                height: _deviceHeight / 40,
              ),
              rateUs1(_deviceHeight, _deviceWidth),
              SizedBox(
                height: _deviceHeight / 60,
              ),
              rateUs2(_deviceHeight, _deviceWidth),
              SizedBox(
                height: _deviceHeight / 60,
              ),
              rateUs3(_deviceHeight, _deviceWidth),
              SizedBox(
                height: _deviceHeight / 60,
              ),
              deleteInformative(_deviceWidth),
              SizedBox(
                height: _deviceHeight / 60,
              ),
              deleteReasonBuilder(_deviceWidth),
              sendDeleteRequestBuilder(
                _deviceHeight,
                _deviceWidth,
              ),
            ],
          ),
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
                  size: deviceHeight / 10,
                ),
                onPressed: () {
                  Navigator.pop(context);
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

  Widget rateUs1(double deviceHeight, double deviceWidth) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: deviceWidth / 24),
          child: Text(
            "1) Could you please relate your leave with the issues below?",
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold, fontSize: deviceWidth / 28),
            textAlign: TextAlign.left,
          ),
        ),
        DropdownButton(
          isDense: true,
          style: const TextStyle(
            color: Colors.black,
          ),
          // Initial Value
          value: rateUs1Answer,
          // Down Arrow Icon
          icon: const Icon(Icons.arrow_drop_down_sharp),
          // Array list of items
          items: rateUs1Answers.map((String answerItem) {
            return DropdownMenuItem(
              value: answerItem,
              child: SizedBox(
                width: deviceWidth * (3 / 4),
                child: Text(
                  answerItem,
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: deviceWidth / 24,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newAnswerValue) {
            setState(() {
              rateUs1Answer = newAnswerValue!;
            });
          },
        ),
      ],
    );
  }

  Widget rateUs2(double deviceHeight, double deviceWidth) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: deviceWidth / 24),
          child: Text(
            "2) Could you please rate our app?",
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold, fontSize: deviceWidth / 28),
            textAlign: TextAlign.left,
          ),
        ),
        RatingBar(
            glowColor: Colors.blue,
            minRating: 1,
            maxRating: 5,
            initialRating: rateUs2Answer,
            allowHalfRating: false,
            ratingWidget: RatingWidget(
              full: const Icon(
                Icons.star,
                color: Color(0xFF414BB2),
              ),
              empty: const Icon(
                Icons.star,
                color: Colors.grey,
              ),
              half: const Icon(
                Icons.star,
                color: Colors.yellowAccent,
              ),
            ),
            onRatingUpdate: (value) {
              rateUs2Answer = value;
            }),
      ],
    );
  }

  Widget rateUs3(double deviceHeight, double deviceWidth) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: deviceWidth / 24),
          child: Text(
            "3) Could you please rate our WashMe system?",
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold, fontSize: deviceWidth / 28),
            textAlign: TextAlign.left,
          ),
        ),
        RatingBar(
            glowColor: Colors.blue,
            minRating: 1,
            maxRating: 5,
            initialRating: rateUs3Answer,
            allowHalfRating: false,
            ratingWidget: RatingWidget(
              full: const Icon(
                Icons.star,
                color: Color(0xFF414BB2),
              ),
              empty: const Icon(
                Icons.star,
                color: Colors.grey,
              ),
              half: const Icon(
                Icons.star,
                color: Colors.yellowAccent,
              ),
            ),
            onRatingUpdate: (value) {
              rateUs3Answer = value;
            }),
      ],
    );
  }

  Widget deleteInformative(double deviceWidth) {
    return Text(
      "You are about to delete your account, we need to have your feedback in order to review your request, take a moment to make us a comment about your leave!",
      style: GoogleFonts.notoSans(
          fontWeight: FontWeight.bold, fontSize: deviceWidth / 26),
      textAlign: TextAlign.center,
    );
  }

  Widget deleteReasonBuilder(double deviceWidth) {
    return const TextField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLength: 1000,
      maxLines: 5,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 3),
        ),
      ),
    );
  }

  Widget sendDeleteRequestBuilder(double deviceHeight, double deviceWidth) {
    return ElevatedButton(
        onPressed: () async {

          showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);

          FirebaseAuth _auth = FirebaseAuth.instance;
          User? user = _auth.currentUser;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .update({
            'washer': false,
          });
          DocumentReference<Map<String, dynamic>>
              washerInformationsDocumentRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection("washer")
                  .doc("washerInformations");
          DocumentSnapshot<Map<String, dynamic>> querySnapshot =
              await washerInformationsDocumentRef.get();
          Map<String, dynamic>? data = querySnapshot.data();
          String simplePath = "washerRegisterPhotos/${data!["washerID"]}/";
          Future.wait([
            StorageHelper.deleteFolder([
              "${simplePath}backOfIDFile",
              "${simplePath}frontOfIDFile",
              "${simplePath}profilePhoto",
              "${simplePath}optionalPhoto"
            ]) as Future<dynamic>
          ]).then((value) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool? _showIntro = prefs.getBool("showIntro");

            if (!mounted) return;
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Splash(showIntro: _showIntro)), (route) => false);
          }
          );

          DocumentReference<Map<String, dynamic>>
              publicWasherInformationsDocumentRef = FirebaseFirestore.instance
                  .collection('washerInformations')
                  .doc(data["washerID"]);

          publicWasherInformationsDocumentRef.delete();
          washerInformationsDocumentRef.delete();
        },
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: deviceWidth / 40, vertical: deviceHeight / 60),
            child: Text(
              "Send Delete My Account Request",
              style: GoogleFonts.openSans(fontSize: deviceWidth / 24),
            )));
  }
}
