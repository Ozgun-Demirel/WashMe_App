
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../InterfaceFunc/screenOpeners/WasherSide/washerRequestsOpener.dart';
import '../../../InterfaceFunc/screenOpeners/showTransparentDialogOnLoad.dart';

class ALWashMeWasher extends StatefulWidget {
  static const routeName = "/ALWashMeWasher";
  const ALWashMeWasher({Key? key}) : super(key: key);

  @override
  State<ALWashMeWasher> createState() => _ALWashMeWasherState();
}

class _ALWashMeWasherState extends State<ALWashMeWasher> {

  @override
  Widget build(BuildContext context) {

    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    double _sloganSize = _deviceWidth/9.5;
    return Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                "lib/Assets/WashMe/SplashScreen/WasherSplash/operatorSplash.gif",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                  children: [
                    SizedBox(
                      height: _deviceHeight / 24,
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        "WashMe Washer",
                        style: GoogleFonts.fredokaOne(
                            fontSize: _deviceWidth / 9, color: Colors.white),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Divider(
                          color: Colors.white30,
                          thickness: 4,
                          endIndent: _deviceWidth / 20,
                          indent: _deviceWidth / 20,
                        )),
                    const Expanded(flex: 12, child: SizedBox()),
                    Expanded(flex: 29, child: Column(
                      children: [
                        Text("Become",style: GoogleFonts.fredokaOne(fontSize: _sloganSize, color: Colors.white),),
                        Text("a Washer",style: GoogleFonts.fredokaOne(fontSize: _sloganSize, color: Colors.white),),
                        Text("and make",style: GoogleFonts.fredokaOne(fontSize: _sloganSize, color: Colors.white),),
                        Text("\$2,200 - \$3,100!",style: GoogleFonts.fredokaOne(fontSize: _sloganSize, color: Colors.white),),
                      ],
                    )),
                    const Expanded(flex: 6, child: SizedBox()),
                    Expanded(
                      flex : 4,
                      child: ElevatedButton(onPressed: () async {

                        showTransparentDialogOnLoad(context, _deviceHeight, _deviceWidth);

                        washerRequestsOpener(context, mounted);
                      },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_deviceWidth/10)),
                        ),
                        child: Text(
                          "Get Started!",
                          style: GoogleFonts.notoSans(
                              fontSize: _deviceWidth / 16, color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Expanded(flex: 3, child: SizedBox()),
                  ]
              ),
            ),

          ],
        ),
    );
  }

}
