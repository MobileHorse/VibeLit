import 'package:flutter/material.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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
                SizedBox(height: 30,),
                Container(width: 100, height: 1, color: Colors.white,),
                SizedBox(height: 30,),
                Text(
                  "the volume of a space \n is calculated by \n multiplying three factor.",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30,),
                Text(
                  "L x P x H",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 50,),
                Text(
                  "values must be over 100 and \n below 5000",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Montserrat'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Text(
                    "Set the intensity from 1 to 5 to increase the ions production during Air Purification mode or make a longer Odour Removal program.\nIncreasing the intensity values also increases the air flow rate of the product",
                    style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Montserrat'),
                    textAlign: TextAlign.center,
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
