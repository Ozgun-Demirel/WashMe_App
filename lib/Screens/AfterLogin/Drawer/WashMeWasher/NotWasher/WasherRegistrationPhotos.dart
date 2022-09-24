import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../FirebaseHelper/StorageHelper/StorageHelper.dart';
import '../../../../../InterfaceFunc/ImageHelper/imagePicker.dart';
import '../../../../../InterfaceFunc/registerWasher.dart';
import '../../../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';

class WasherRegistrationPhotos extends StatefulWidget {
  static const routeName = "/WasherRegistrationPhotos";
  const WasherRegistrationPhotos({Key? key}) : super(key: key);

  @override
  State<WasherRegistrationPhotos> createState() =>
      _WasherRegistrationPhotosState();
}

class _WasherRegistrationPhotosState extends State<WasherRegistrationPhotos> {
  File? profilePhotoFile;
  File? optionalPhotoFile;

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
            SizedBox(
              height: _deviceHeight / 30,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                "Uplaod Your Personal Photo",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
              ),
            ),
            SizedBox(
              height: _deviceHeight / 60,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(right: _deviceWidth / 40),
              child: Text(
                "Your photos help people recognize you. Please note that once you upload your photos, they CAN NOT BE CHANGED.",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
              ),
            ),
            SizedBox(
              height: _deviceHeight / 30,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                "1. Profile Photo",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(right: _deviceWidth / 6),
              child: Text(
                "Face the camera. Make sure your eyes and mouth are clearly visible.",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
              ),
            ),
            SizedBox(
              height: _deviceHeight / 60,
            ),
            profilePhotoBuilder(_deviceHeight, _deviceWidth, context),
            SizedBox(
              height: _deviceHeight / 40,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                "2. Photo showing you washing a car (optional)",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: _deviceWidth / 21),
              ),
            ),
            SizedBox(
              height: _deviceHeight / 60,
            ),
            workPhotoBuilder(_deviceHeight, _deviceWidth, context),
            SizedBox(
              height: _deviceHeight / 40,
            ),
            photoUploaderButtonBuilder(_deviceHeight, _deviceWidth),
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

  Widget profilePhotoBuilder(
      double deviceHeight, double deviceWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              EdgeInsets.only(left: deviceWidth / 20, right: deviceWidth / 20),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF2D9BF0),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: deviceHeight / 40,
                        bottom: deviceHeight / 40,
                      ),
                      child: Text(
                        "Open Camera",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(fontSize: deviceWidth / 24),
                      ),
                    ),
                    onPressed: () async {
                      File? fileName = await ImagePickerHelper.takePicture();
                      if (fileName == null) {
                        return;
                      } else {
                        profilePhotoFile = fileName;
                        setState(() {});
                      }
                    },
                  )),
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "or",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(fontSize: deviceWidth / 24),
                    ),
                  )),
              Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF2D9BF0),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: deviceHeight / 40,
                        bottom: deviceHeight / 40,
                      ),
                      child: Text(
                        "Open Galery",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(fontSize: deviceWidth / 24),
                      ),
                    ),
                    onPressed: () async {
                      File? fileName = await ImagePickerHelper.selectPicture();
                      if (fileName == null) {
                        return;
                      } else {
                        profilePhotoFile = fileName;
                        setState(() {});
                      }
                    },
                  )),
            ],
          ),
        ),
        SizedBox(
          height: deviceHeight / 40,
        ),
        Container(
          height: deviceHeight / 4,
          decoration:
              BoxDecoration(border: Border.all(color: const Color(0xFF414BB2))),
          child: profilePhotoFile == null
              ? null
              : Image.file(
                  profilePhotoFile as File,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),
      ],
    );
  }

  Widget workPhotoBuilder(
      double deviceHeight, double deviceWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: deviceWidth / 20, right: deviceWidth / 20),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF2D9BF0),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: deviceHeight / 40,
                        bottom: deviceHeight / 40,
                      ),
                      child: Text(
                        "Open Camera",
                        textAlign: TextAlign.center,
                        style:
                            GoogleFonts.openSans(fontSize: deviceWidth / 24),
                      ),
                    ),
                    onPressed: () async {
                      File? fileName = await ImagePickerHelper.takePicture();
                      if (fileName == null) {
                        return;
                      } else {
                        optionalPhotoFile = fileName;
                        setState(() {});
                      }
                    },
                  )),
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "or",
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.openSans(fontSize: deviceWidth / 24),
                    ),
                  )),
              Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF2D9BF0),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: deviceHeight / 40,
                        bottom: deviceHeight / 40,
                      ),
                      child: Text(
                        "Open Galery",
                        textAlign: TextAlign.center,
                        style:
                            GoogleFonts.openSans(fontSize: deviceWidth / 24),
                      ),
                    ),
                    onPressed: () async {
                      File? fileName =
                          await ImagePickerHelper.selectPicture();
                      if (fileName == null) {
                        return;
                      } else {
                        optionalPhotoFile = fileName;
                        setState(() {});
                      }
                    },
                  )),
            ],
          ),
        ),
        SizedBox(
          height: deviceHeight / 40,
        ),
        Container(
          height: deviceHeight / 4,
          decoration:
              BoxDecoration(border: Border.all(color: const Color(0xFF414BB2))),
          child: optionalPhotoFile == null
              ? null
              : Image.file(
                  optionalPhotoFile as File,
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

          showTransparentDialogOnLoad(context, deviceHeight, deviceWidth);

          FocusScope.of(context).unfocus();


          if (profilePhotoFile != null){
            var auth = FirebaseAuth.instance;
            var user = auth.currentUser;
            String? optionalPhotoURL;
            String? profilePhotoURL ;


            DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore.instance.collection('users')
                .doc(user!.uid)
                .collection("washer")
                .doc("washerInformations");
            DocumentSnapshot<Map<String, dynamic>> querySnapshot = await documentRef.get();
            Map<String, dynamic>? data = querySnapshot.data();

              if (data!.containsKey("photosURL")){
                if(!mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(duration: Duration(seconds: 5),content: Text("You can not add new values here.")),
                );
                return;
              }
              else {
               profilePhotoURL = await StorageHelper.uploadFile(profilePhotoFile as File, "washerRegisterPhotos/${data["washerID"]}/profilePhoto");

                if (optionalPhotoFile != null){
                  optionalPhotoURL = await StorageHelper.uploadFile(optionalPhotoFile as File, "washerRegisterPhotos/${data["washerID"]}/optionalPhoto");
                }
                data.addAll({"photosURL" : {"profilePhotoURL": profilePhotoURL.toString(), "optionalPhotoURL": optionalPhotoURL.toString()}});
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
            Navigator.of(context).pop();
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
