import 'package:flutter/material.dart';
import 'package:vibelit/config/constants.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  double space = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryGrey,
      body: Stack(
        children: [
          Positioned(
            top: 60,
            right: 20,
            child: IconCircleButton(
              icon: Icon(
                Icons.close,
                size: 24,
                color: Colors.white,
              ),
              onClick: () {
                Navigator.pop(context);
              },
              size: 24,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Intensity",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                    ),
                    SizedBox(width: 6,),
                    Text(
                      "Info",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Montserrat'),
                    ),
                  ],
                ),
                SizedBox(height: space,),
                Container(width: 100, height: 1, color: Colors.white,),
                SizedBox(height: space,),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      "Set the intensity from ${Constants.INTENSITY_MIN} to ${Constants.INTENSITY_MAX} to increase the ions production during Air Purification mode or make a longer Odour Removal program.\nIncreasing the intensity values also increases the air flow rate of the product",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
                      textAlign: TextAlign.center,
                    )
                ),
                SizedBox(height: 80,),
                Text(
                  "How to calculate",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 6,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "the",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Montserrat'),
                    ),
                    SizedBox(width: 6,),
                    Text(
                      "volume",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                    ),
                  ],
                ),
                SizedBox(height: space,),
                Container(width: 100, height: 1, color: Colors.white,),
                SizedBox(height: space,),
                Text(
                  "the volume of a space \n is calculated by \n multiplying three factor.",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: space,),
                Text(
                  "L x P x H",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                ),
                SizedBox(height: space,),
                Text(
                  "values must be over ${Constants.VOLUME_MIN} and \n below ${Constants.VOLUME_MAX}",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Montserrat'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
