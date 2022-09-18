

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarInformation(double deviceHeight, double deviceWidth, BuildContext context, String message, {int? durationMilliSec}) {

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.blueAccent,
        duration: Duration(milliseconds: durationMilliSec ?? 4000),
        content: Container(
        height: deviceHeight/12,
        child: Center(child: Text(message,
          style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: deviceWidth / 24), textAlign: TextAlign.center,),))),
  );


}