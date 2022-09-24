import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../FirebaseHelper/StorageHelper/StorageHelper.dart';
import '../../../../../InterfaceFunc/ImageHelper/imagePicker.dart';
import '../../../../../InterfaceFunc/registerWasher.dart';
import '../../../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';

class WasherRegistrationID extends StatefulWidget {
  static const routeName = "/WasherRegistrationID";
  const WasherRegistrationID({Key? key}) : super(key: key);

  @override
  State<WasherRegistrationID> createState() => _WasherRegistrationIDState();
}

class _WasherRegistrationIDState extends State<WasherRegistrationID> {
  File? frontOfIDFile;
  File? backOfIDFile;


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
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Uplaod Your ID",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                  ),
                ),
                SizedBox(
                  height: _deviceHeight / 60,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(right: _deviceWidth/20),
                  child: Text(
                    "Upload your goverment issued ID. Acceptable IDs are driver's licence, state issued ID, permanent resident card (green card) or passport. Make sure the document has not Expired.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                  ),
                ),
                SizedBox(
                  height: _deviceHeight / 30,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(right: _deviceWidth/20),
                  child: Text(
                    "1. Front of your ID or photo identification page of your passport",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                  ),
                ),
                SizedBox(
                  height: _deviceHeight / 60,
                ),
                frontOfIDPhotoBuilder(_deviceHeight, _deviceWidth, context),
                SizedBox(
                  height: _deviceHeight / 40,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "2. Back of your ID. Leave blank for passport.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _deviceWidth / 20),
                  ),
                ),
                SizedBox(
                  height: _deviceHeight / 60,
                ),
                backOfIDPhotoBuilder(_deviceHeight, _deviceWidth, context),
                SizedBox(height: _deviceHeight/40,),
                photoUploaderButtonBuilder(_deviceHeight, _deviceWidth),
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
                size: deviceWidth / 12,
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

  Widget frontOfIDPhotoBuilder(double deviceHeight, double deviceWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: deviceWidth/20, right: deviceWidth/20),
          child: Row(
            children: [
              Expanded(flex: 4, child: ElevatedButton(style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2D9BF0),
              ),
                child: Container(
                  margin: EdgeInsets.only(top: deviceHeight/40, bottom: deviceHeight/40,),
                  child: Text("Open Camera",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                        fontSize: deviceWidth / 24),),
                ), onPressed: () async {
                  File? fileName = await ImagePickerHelper.takePicture();
                  if (fileName == null) {
                    return;
                  } else {
                    frontOfIDFile = fileName;
                    setState(() {});
                  }
                },)),
              Expanded(flex: 1, child: Center(child: Text("or",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                    fontSize: deviceWidth / 24),),)),
              Expanded(flex: 4, child: ElevatedButton(style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2D9BF0),
              ),
                child: Container(
                  margin: EdgeInsets.only(top: deviceHeight/40, bottom: deviceHeight/40,),
                  child: Text("Open Galery",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                        fontSize: deviceWidth / 24),),
                ), onPressed: () async {
                  File? fileName = await ImagePickerHelper.selectPicture();
                  if (fileName == null) {
                    return;
                  } else {
                    frontOfIDFile = fileName;
                    setState(() {});
                  }
                },)),
            ],
          ),
        ),
        SizedBox(height: deviceHeight/40,),
        Container(
          height: deviceHeight/4,
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFF414BB2))),
          child: frontOfIDFile == null
              ? null
              : Image.file(
            frontOfIDFile as File,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ],
    );
  }

  Widget backOfIDPhotoBuilder(double deviceHeight, double deviceWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: deviceWidth/20, right: deviceWidth/20),
          child: Row(
            children: [
              Expanded(flex: 4, child: ElevatedButton(style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2D9BF0),
              ),
                child: Container(
                  margin: EdgeInsets.only(top: deviceHeight/40, bottom: deviceHeight/40,),
                  child: Text("Open Camera",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                        fontSize: deviceWidth / 24),),
                ), onPressed: () async {
                  File? fileName = await ImagePickerHelper.takePicture();
                  if (fileName == null) {
                    return;
                  } else {
                    backOfIDFile = fileName;
                    setState(() {});
                  }
                },)),
              Expanded(flex: 1, child: Center(child: Text("or",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                    fontSize: deviceWidth / 24),),)),
              Expanded(flex: 4, child: ElevatedButton(style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2D9BF0),
              ),
                child: Container(
                  margin: EdgeInsets.only(top: deviceHeight/40, bottom: deviceHeight/40,),
                  child: Text("Open Galery",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                        fontSize: deviceWidth / 24),),
                ), onPressed: () async {
                  File? fileName = await ImagePickerHelper.selectPicture();
                  if (fileName == null) {
                    return;
                  } else {
                    backOfIDFile = fileName;
                    setState(() {});
                  }
                },)),
            ],
          ),
        ),
        SizedBox(height: deviceHeight/40,),
        Container(
          height: deviceHeight/4,
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFF414BB2))),
          child: backOfIDFile == null
              ? null
              : Image.file(
            backOfIDFile as File,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ],
    );
  }

  Widget photoUploaderButtonBuilder(double deviceHeight, double deviceWidth) {
    return ElevatedButton(
        onPressed: () async {

          FocusScope.of(context).unfocus();

          showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);

          if (frontOfIDFile != null){
            var auth = FirebaseAuth.instance;
            var user = auth.currentUser;
            String? backOfIDFileURL;
            String? frontOfIDFileURL ;

            DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore.instance.collection('users')
                .doc(user!.uid)
                .collection("washer")
                .doc("washerInformations");
            DocumentSnapshot<Map<String, dynamic>> querySnapshot = await documentRef.get();
            Map<String, dynamic>? data = querySnapshot.data();

              if (data!.containsKey("IDURL")){
                if (!mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(duration: Duration(seconds: 5),content: Text("You can not add new values here.")),
                );
                return;
              }
              else {
                frontOfIDFileURL = await StorageHelper.uploadFile(frontOfIDFile as File, "washerRegisterPhotos/${data["washerID"]}/frontOfIDFile");

                if (backOfIDFile != null){
                  backOfIDFileURL = await StorageHelper.uploadFile(backOfIDFile as File, "washerRegisterPhotos/${data["washerID"]}/backOfIDFile");
                }
                data.addAll({"IDURL" : {"frontOfIDFileURL": frontOfIDFileURL.toString(), "backOfIDFileURL": backOfIDFileURL.toString()}});
                documentRef.set(data);

                var keys = data.keys;

                if(!mounted) return;
                registerWasher(data, keys, context, mounted);

              }

            if(!mounted) return;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(duration: Duration(seconds: 3),content: Text('Photos are uploaded successfully')),
            );
            Navigator.of(context).pushReplacementNamed("/WasherRegistration");

          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(duration: Duration(seconds: 3),content: Text('You have to register a profile photo.')),
            );
            return;
          }


        },
        child: Container(
          margin: EdgeInsets.only(
              right: deviceWidth / 10,
              left: deviceWidth / 10,
              top: deviceWidth / 20,
              bottom: deviceWidth / 20),
          child: Text("Done",
              style: TextStyle(fontSize: deviceWidth / 20)),
        ));
  }
}
