import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibelit/bloc/bloc.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/screen/stop_air_purification_screen.dart';
import 'package:vibelit/util/preference_helper.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';

class AirPurificationScreen extends StatefulWidget {
  @override
  _AirPurificationScreenState createState() => _AirPurificationScreenState();
}

class _AirPurificationScreenState extends State<AirPurificationScreen> {

  PurificationBloc _purificationBloc;

  @override
  void initState() {
    super.initState();
    _purificationBloc = BlocProvider.of<PurificationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryGrey,
      body: Column(
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
                    size: 24,
                    color: Colors.white,
                  ),
                  onClick: () {
                    Navigator.pop(context);
                  },
                  size: 24,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: Image.asset(
                "assets/images/bar.png",
                height: double.infinity,
              )),
          SizedBox(
            height: 30,
          ),
          Text(
            "Mode selected",
            style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Montserrat'),
          ),
          SizedBox(height: 10,),
          Text(
            "AIR PURIFICATION",
            style: TextStyle(color: Styles.bgGreen, fontSize: 24, fontFamily: 'Montserrat'),
          ),
          SizedBox(height: 40,),
          Container(
            width: 200,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32)
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      PreferenceHelper.getInt(Params.intensity).toString(),
                      style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.white,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      PreferenceHelper.getInt(Params.volume).toString(),
                      style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 200,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Intensity",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Volume(m3)",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 60,),
          TextButton(
            child: Text(
              "Start",
              style: TextStyle(color: Styles.bgGreen, fontSize: 20, fontFamily: 'Montserrat'),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              backgroundColor: Colors.white.withOpacity(0.1),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
            ),
            onPressed: () {
              _purificationBloc.add(PurificationStartEvent());
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StopAirPurificationScreen(),));
            },
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
