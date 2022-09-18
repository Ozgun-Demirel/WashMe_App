

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

Widget progressIndicator(){
  if (Platform.isAndroid){
    return const CircularProgressIndicator();
  } else {
    return const CupertinoActivityIndicator(radius: 20, color: Colors.white, );
  }
}