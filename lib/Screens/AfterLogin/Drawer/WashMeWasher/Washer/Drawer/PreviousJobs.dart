import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PreviousJobs extends StatelessWidget {
  static const routeName = "/PreviousJobs";
  const PreviousJobs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map<String, dynamic>;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> previousJobs = arguments["previousJobs"] as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

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
                SizedBox(width: double.infinity, child: Text("Previous Jobs:", style: GoogleFonts.notoSans(fontWeight: FontWeight.bold, fontSize: _deviceWidth/21),),),
                SizedBox(height: _deviceHeight/45,),

                previousJobs.isEmpty ? const Text("There are no previous jobs!") : previousJobsBuilder(_deviceHeight, _deviceWidth, previousJobs),
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

  previousJobsBuilder(double deviceHeight, double deviceWidth, List<QueryDocumentSnapshot<Map<String, dynamic>>> previousJobs) {

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: previousJobs.length,
      itemBuilder: (context, index){

        Map<String, dynamic> currentPreviousOrder = previousJobs[index].data();

        final df = DateFormat('dd-MM-yyyy hh:mm a');
        String orderDate = df.format(
            DateTime.fromMillisecondsSinceEpoch(
                currentPreviousOrder["orderDate"].seconds * 1000));

        String extraWashTypes = "Extras: ";
        for (int extraLength = 0;
        extraLength < currentPreviousOrder["washType"]["extras"].length;
        extraLength++) {
          extraWashTypes +=
              currentPreviousOrder["washType"]["extras"][extraLength] + "/";
        }
        extraWashTypes = extraWashTypes.substring(
            0,
            extraWashTypes.length -
                1); // deleted last character from string. which in this case removes excess /

        return Column(
          children: [
            Card(
                shadowColor: Colors.blueAccent,
                elevation: 8,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceWidth / 20)),
                child: Container(
                  padding: EdgeInsets.all(deviceWidth / 40),
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          colors: [currentPreviousOrder["isCompleted"] ? Colors.green : Colors.red , currentPreviousOrder["isCompleted"] ? Colors.blue: Colors.deepOrange],
                          center: Alignment.center,
                          radius: 2)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: deviceHeight / 80,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          currentPreviousOrder["carType"],
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: deviceWidth / 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          currentPreviousOrder["washType"]["exterior"],
                          style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          currentPreviousOrder["washType"]["extras"].length == 0
                              ? "No Extra"
                              : extraWashTypes,
                          style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          currentPreviousOrder["streetNumberAndName"],
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: deviceWidth / 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          orderDate,
                          style: GoogleFonts.openSans(
                              fontSize: deviceWidth / 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight / 40,
                      ),
                    ],
                  ),
                )
            )
          ],
        );
      },
    );

  }

  }

