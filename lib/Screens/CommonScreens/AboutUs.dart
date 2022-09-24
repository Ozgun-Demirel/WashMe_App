import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);
  static const routeName = "/AboutUs";
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
                hamMenuAndTitle(_deviceWidth, context),
                SizedBox(height: _deviceHeight/30,),
                SizedBox(width: double.infinity, child: Text("About Us", style: GoogleFonts.notoSans(fontWeight: FontWeight.bold, fontSize: _deviceWidth/21),),),
                SizedBox(height: _deviceHeight/45,),
                Text("About our corporation", style: GoogleFonts.notoSans(fontWeight: FontWeight.bold, fontSize: _deviceWidth/24)),
                SizedBox(height: _deviceHeight/45,),
                Container(
                    padding: EdgeInsets.only(left: _deviceWidth/10, right: _deviceWidth/10),
                    child: Text("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                    )),

                SizedBox(height: _deviceHeight/20,),

                Image.asset(
                  "lib/Assets/WashMe/CommonScreens/alp.png",
                  height: _deviceHeight / 5,
                ),
                SizedBox(height: _deviceHeight/60,),

                Container(
                    padding: EdgeInsets.only(left: _deviceWidth/10, right: _deviceWidth/10),
                    child: Column(
                      children: [
                        Text("Alp Erk",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                        ),
                        Text("CEO",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                        ),
                        Text("Short Bio",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: _deviceHeight/80,),
                      ],
                    )),

                Image.asset(
                  "lib/Assets/WashMe/CommonScreens/bilal.jpg",
                  height: _deviceHeight / 5,
                ),
                SizedBox(height: _deviceHeight/60,),

                Container(
                    padding: EdgeInsets.only(left: _deviceWidth/10, right: _deviceWidth/10),
                    child: Column(
                      children: [
                        Text("Bilal Nevarlı",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                        ),
                        Text("Co. CEO",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                        ),
                        Text("Short Bio",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: _deviceHeight/80,),
                      ],
                    )),

                Image.asset(
                  "lib/Assets/WashMe/CommonScreens/şükrü.jpg",
                  height: _deviceHeight / 5,
                ),
                SizedBox(height: _deviceHeight/60,),

                Container(
                    padding: EdgeInsets.only(left: _deviceWidth/10, right: _deviceWidth/10),
                    child: Column(
                      children: [
                        Text("Şükrü Özgün Demirel",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                        ),
                        Text("CTO",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                        ),
                        Text("Short Bio",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: _deviceHeight/80,),
                      ],
                    )),

              ],
            ),
          ),
        )
    );
  }

  hamMenuAndTitle(double deviceHeight, BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: SizedBox(
              height:  deviceHeight / 6.6,
              child: TextButton(
                child: Icon(
                  Icons.keyboard_backspace,
                  color: const Color(0xFF2D9BF0),
                  size: deviceHeight / 6.6,
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
}
