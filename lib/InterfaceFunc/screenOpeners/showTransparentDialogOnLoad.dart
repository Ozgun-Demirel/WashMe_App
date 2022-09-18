


import 'package:flutter/material.dart';

import '../platformDependedWidgetChanges.dart';

showTransparentDialogOnLoad(BuildContext context, double deviceHeight, double deviceWidth){
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: deviceWidth,
              height: deviceHeight,
              child: Center(
                child: progressIndicator(),
              ),
            )
          ],
        );
      });
}