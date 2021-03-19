import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibelit/bloc/bloc.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/screen/parameter_screen.dart';
import 'package:vibelit/screen/parameter_setting.dart';
import 'package:vibelit/util/preference_helper.dart';
import 'package:vibelit/widget/button/feature_button.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';
import 'package:vibelit/widget/switch/switch.dart';

import 'air_purification_screen.dart';

class OnOffScreen extends StatefulWidget {
  @override
  _OnOffScreenState createState() => _OnOffScreenState();
}

class _OnOffScreenState extends State<OnOffScreen> {

  bool onOffValue;
  StatusBloc _statusBloc;

  @override
  void initState() {
    super.initState();
    _statusBloc = BlocProvider.of<StatusBloc>(context);
    onOffValue = PreferenceHelper.getBool(Params.status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryGrey,
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
                    Icons.settings,
                    size: 24,
                    color: Colors.white,
                  ),
                  onClick: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ParameterSettingScreen(),));
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
          FlutterSwitch(
            value: onOffValue,
            activeColor: Color(0xFF27ba03),
            onToggle: (bool value) {
              setState(() {
                onOffValue = value;
              });
              if (value) _statusBloc.add(StatusOnEvent());
              else _statusBloc.add(StatusOffEvent());
            },
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("on", style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(onOffValue ? 1 : 0.3)),),
              SizedBox(width: 4,),
              Text("/", style: TextStyle(fontSize: 10, color: Colors.white),),
              SizedBox(width: 4,),
              Text("off", style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(!onOffValue ? 1 : 0.3)),),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FeatureButton(
                caption: "Light",
                asset: "assets/images/ic_light.png",
                onClick: () {

                },
              ),
              SizedBox(
                width: 30,
              ),
              FeatureButton(
                caption: "Light",
                asset: "assets/images/ic_music.png",
                onClick: () {},
              ),
              SizedBox(
                width: 30,
              ),
              FeatureButton(
                caption: "Parameters",
                asset: "assets/images/ic_graph.png",
                onClick: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ParameterScreen(),));
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FeatureButton(
                caption: "Air",
                asset: "assets/images/ic_air.png",
                onClick: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AirPurificationScreen(),
                      ));
                },
              ),
              SizedBox(
                width: 30,
              ),
              FeatureButton(
                caption: "Odour",
                asset: "assets/images/ic_smell.png",
                onClick: () {},
              ),
              SizedBox(
                width: 30,
              ),
              FeatureButton(
                caption: "Surfaces",
                asset: "assets/images/ic_surfaces.png",
                onClick: () {},
              ),
            ],
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
