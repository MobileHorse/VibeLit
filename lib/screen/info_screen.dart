import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';
import 'package:vibelit/widget/card_container.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {

  String version;

  @override
  void initState() {
    super.initState();
    version = "";
    getVersion();
  }

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgPurple,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconCircleButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      size: 32,
                      color: Styles.txtColor,
                    ),
                    onClick: () {
                      Navigator.pop(context);
                    },
                    size: 24,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Text(
              "INFO",
              style: TextStyle(color: Styles.txtColor, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
            ),
            SizedBox(height: 4,),
            Text(
              "and curiositys",
              style: TextStyle(color: Styles.txtColor, fontSize: 28, fontFamily: 'Montserrat'),
            ),
            SizedBox(height: 30,),
            Column(
              children: [
                CardContainerWidget(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: double.infinity, height: 1,),
                      Text(
                        "IAQ value",
                        style: TextStyle(color: Styles.txtColor, fontSize: 24, fontFamily: 'Montserrat'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Indoor air quality (IAQ) is the air quality within and around buildings and structures. IAQ affect the health, comfort, and well-being of building occupants. These values range between 0(clean air) and 500 (heavily polluted air) to indicate or quantify the quality of the air available in the surrounding.",
                        style: TextStyle(color: Styles.txtColor, fontSize: 14, fontFamily: 'Montserrat'),
                      ),
                      SizedBox(height: 40,)
                    ],
                  ),
                ),
                Transform.translate(
                    offset: Offset(0, -50),
                    child: CardContainerWidget(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: double.infinity, height: 1,),
                          Text(
                            "Air purification",
                            style: TextStyle(color: Styles.txtColor, fontSize: 24, fontFamily: 'Montserrat'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Ion production for continuously air purification.",
                            style: TextStyle(color: Styles.txtColor, fontSize: 14, fontFamily: 'Montserrat'),
                          ),
                          SizedBox(height: 40,)
                        ],
                      ),
                    )
                ),
                Transform.translate(
                    offset: Offset(0, -100),
                    child: CardContainerWidget(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: double.infinity, height: 1,),
                          Text(
                            "Odour Removal",
                            style: TextStyle(color: Styles.txtColor, fontSize: 24, fontFamily: 'Montserrat'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Timed increased ion generation to remove unpleasant odours.",
                            style: TextStyle(color: Styles.txtColor, fontSize: 14, fontFamily: 'Montserrat'),
                          ),
                          SizedBox(height: 40,)
                        ],
                      ),
                    )
                ),
                Transform.translate(
                    offset: Offset(0, -150),
                    child: CardContainerWidget(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: double.infinity, height: 1,),
                          Text(
                            "Surface disinfection",
                            style: TextStyle(color: Styles.txtColor, fontSize: 24, fontFamily: 'Montserrat'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Production of ions and highly oxidising active species that guarantee complete disinfection of the air and all surfaces. ",
                            style: TextStyle(color: Styles.txtColor, fontSize: 14, fontFamily: 'Montserrat'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "IMPORTANT: IT IS STRICTLY FORBIDDEN TO ENTER THE AREA WHILE THE IS UNDER WAY",
                            style: TextStyle(color: Styles.txtColor, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Montserrat'),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
            Text(
              "App version: $version",
              style: TextStyle(color: Styles.txtColor, fontSize: 14, fontFamily: 'Montserrat'),
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}
