import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Intro extends StatefulWidget {
  static const routeName = "/Intro";
  const Intro({Key? key}) : super(key: key);
  @override
  State<Intro> createState() => _Intro1State();
}

class _Intro1State extends State<Intro> {
  int pageNum = 1;
  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            pageNum == 1
                ? "lib/Assets/WashMe/SplashScreen/Intro1.gif"
                : pageNum == 2
                    ? "lib/Assets/WashMe/SplashScreen/Intro2.gif"
                    : "lib/Assets/WashMe/SplashScreen/Intro3.gif",
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
                flex: 3,
                child: Text(
                  "WashMe",
                  style: GoogleFonts.fredokaOne(
                      fontSize: _deviceWidth / 9, color: Colors.white),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Divider(
                    color: Colors.blueGrey,
                    thickness: 3,
                    endIndent: _deviceWidth / 20,
                    indent: _deviceWidth / 20,
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  pageNum == 1 ? "Waterjet or Vapor" : pageNum == 2 ? "Bucket and Sponge" : "Interior and Car Detailing",
                  style: GoogleFonts.fredokaOne(
                      fontSize: _deviceWidth / 16, color: Colors.white),
                ),
              ),
              Expanded(flex: 20, child: SizedBox()),
              Expanded(
                flex: 6,
                child: Row(
                  children: [
                    Expanded(flex: 4, child: SizedBox()),
                    Expanded(
                      flex: 6,
                      child: pageNum != 1
                          ? TextButton(
                              onPressed: () {
                                pageNum += -1;
                                setState((){});
                              },
                              child: Image.asset(
                                "lib/Assets/WashMe/SplashScreen/IntroLeftArrow.png", height: _deviceWidth/2,
                              ),
                            )
                          : SizedBox(),
                    ),
                    Expanded(flex: 2,child: SizedBox()),
                    Expanded(
                      flex: 6,
                      child:  TextButton(
                              onPressed: () {
                                if (pageNum == 3){
                                  Navigator.of(context).pushReplacementNamed("/Splash");
                                } else {
                                  pageNum++;
                                  setState((){});
                                }
                              },
                              child: Image.asset(
                                "lib/Assets/WashMe/SplashScreen/IntroRightArrow.png", height: _deviceWidth/2,
                              )),
                    ),
                    Expanded(flex: 4, child: SizedBox()),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Text("$pageNum/3",
                  style: GoogleFonts.fredokaOne(
                      fontSize: _deviceWidth / 16, color: Colors.white),),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
