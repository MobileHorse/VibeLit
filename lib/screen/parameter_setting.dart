import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vibelit/config/application.dart';
import 'package:vibelit/config/constants.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/screen/help_screen.dart';
import 'package:vibelit/util/preference_helper.dart';
import 'package:vibelit/util/toasts.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';
import 'package:vibelit/widget/number_picker.dart';

class ParameterSettingScreen extends StatefulWidget {
  @override
  _ParameterSettingScreenState createState() => _ParameterSettingScreenState();
}

class _ParameterSettingScreenState extends State<ParameterSettingScreen> {

  int intensity;
  TextEditingController volumeController;

  @override
  void initState() {
    super.initState();
    intensity = PreferenceHelper.getInt(Params.intensity);
    volumeController = TextEditingController();
    volumeController.text = PreferenceHelper.getInt(Params.volume).toString();
  }

  @override
  void dispose() {
    volumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryGrey,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 60),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconCircleButton(
                  icon: Icon(
                    Icons.info_outline,
                    size: 24,
                    color: Colors.white,
                  ),
                  onClick: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen(),));
                  },
                  size: 24,
                ),
                IconCircleButton(
                  icon: Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.white,
                  ),
                  onClick: () {
                    Navigator.pop(context);
                  },
                  size: 24,
                )
              ],
            ),
          ),
          Expanded(child: Container()),
          Text(
            "Parameters \n Settings",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'Montserrat'),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 60,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(left: 20), child: Text(
                "INTENSITY",
                style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Montserrat'),
              ),),
              SizedBox(height: 12,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32)
                ),
                child: NumberPicker.integer(
                  initialValue: intensity,
                  minValue: Constants.INTENSITY_MIN,
                  maxValue: Constants.INTENSITY_MAX,
                  listViewWidth: 260,
                  listViewHeight: 60,
                  horizontal: true,
                  onChanged: (value) {
                    if (value >= Constants.INTENSITY_MIN && value <= Constants.INTENSITY_MAX) {
                      setState(() {
                        intensity = value;
                      });
                    }
                  },
                  defaultTextStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 20, fontFamily: 'Montserrat'),
                  selectedTextStyle: TextStyle(color: Colors.white, fontSize: 36, fontFamily: 'Montserrat'),
                ),
              ),
            ],
          ),
          SizedBox(height: 50,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(left: 20), child: Text(
                "VOLUME (from 100 to 5000)",
                style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Montserrat'),
              ),),
              SizedBox(height: 12,),
              Container(
                width: 280,
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32)
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 100,
                            child: TextField(
                              controller: volumeController,
                              style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: 'Montserrat'),
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(0),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Text("m3", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Montserrat'),)
                        ],
                      ),
                      Container(
                        width: 160,
                        height: 1,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          TextButton(
            child: Text(
              "Set",
              style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Montserrat'),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              backgroundColor: Colors.white.withOpacity(0.1),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
            ),
            onPressed: () {
              if (int.parse(volumeController.text) > 99 && int.parse(volumeController.text) < 5001) {
                PreferenceHelper.setInt(Params.volume, int.parse(volumeController.text));
                PreferenceHelper.setInt(Params.intensity, intensity);
              } else {
                ToastUtils.showErrorToast(context, "Volume value must be between 100 and 5000");
              }
            },
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
