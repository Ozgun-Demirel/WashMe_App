
import 'package:WashMe/InterfaceFunc/DatabaseHelpers/customerLocations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  static const routeName = "/Splash";
  bool? showIntro;
  Splash({Key? key, this.showIntro}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}


class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {

    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final sloganSize = _deviceWidth/12;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "lib/Assets/WashMe/SplashScreen/Splash.gif",
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
                    "WashMe",
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
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 40,
                  child: Column(
                    children: [
                      Text(
                        "We Wash",
                        style: GoogleFonts.fredokaOne(
                            fontSize: sloganSize, color: Colors.white),
                      ),
                      Text(
                        "Your Cars",
                        style: GoogleFonts.fredokaOne(
                            fontSize: sloganSize, color: Colors.white),
                      ),
                      Text(
                        "Anywhere,",
                        style: GoogleFonts.fredokaOne(
                            fontSize: sloganSize, color: Colors.white),
                      ),
                      Text(
                        "Anytime!",
                        style: GoogleFonts.fredokaOne(
                            fontSize: sloganSize, color: Colors.white),
                      ),
                      Text(
                        "While You Are",
                        style: GoogleFonts.fredokaOne(
                            fontSize: sloganSize, color: Colors.white),
                      ),
                      Text(
                        "Working",
                        style: GoogleFonts.fredokaOne(
                            fontSize: sloganSize, color: Colors.white),
                      ),
                      Text(
                        "Shopping",
                        style: GoogleFonts.fredokaOne(
                            fontSize: sloganSize, color: Colors.white),
                      ),
                      Text(
                        "Partying",
                        style: GoogleFonts.fredokaOne(
                            fontSize: sloganSize, color: Colors.white),
                      ),
                      Text(
                        "even",
                        style: GoogleFonts.fredokaOne(
                            fontSize: sloganSize, color: Colors.white),
                      ),
                      Text(
                        "Sleeping",
                        style: GoogleFonts.fredokaOne(
                            fontSize: sloganSize, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(width: 2.0, color: Colors.white),
                        ),
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.all(Color(0xFF2D9BF0)),
                        value: !(widget.showIntro ?? true),
                        onChanged: (bool? value) async {

                          SharedPreferences prefs = await SharedPreferences.getInstance();

                          await prefs.setBool("showIntro", !value!);

                          widget.showIntro = !value;

                          setState(() {});

                        },
                      ),
                      TextButton(
                        onPressed: () async {

                          widget.showIntro = !(widget.showIntro?? true);

                          SharedPreferences prefs = await SharedPreferences.getInstance();

                          await prefs.setBool("showIntro", (widget.showIntro ?? false));

                          setState(() {});
                        },
                        child: Text(
                          "Do not show the intro again!",
                          style: GoogleFonts.fredokaOne(
                              fontSize: sloganSize / 2, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    onPressed: () async {

                      await CustomerLocation.checkPermission();

                      if (!mounted) return;
                      Navigator.of(context).pushReplacementNamed("/HoldToLoad");
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_deviceWidth/10)),
                    ),
                    child: Text(
                      "Get Started!",
                      style: GoogleFonts.notoSans(
                          fontSize: _deviceWidth / 16, color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Expanded(flex: 3, child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
