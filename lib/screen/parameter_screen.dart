import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibelit/bloc/weather_bloc/bloc.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';
import 'package:vibelit/widget/graph_widget.dart';
import 'package:weather_icons/weather_icons.dart';

class ParameterScreen extends StatefulWidget {
  @override
  _ParameterScreenState createState() => _ParameterScreenState();
}

class _ParameterScreenState extends State<ParameterScreen> {
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: new BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "ON",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    )
                  ],
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
          buildWeather(),
          Expanded(child: Container()),
          Text(
            "Air quality parameters",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
          ),
          SizedBox(height: 10,),
          Text(
            "Indoor",
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16, fontFamily: 'Montserrat'),
          ),
          SizedBox(height: 30,),
          GraphWidget(
            title: "Umidità",
            percent: 90,
          ),
          SizedBox(height: 10,),
          GraphWidget(
            title: "Polveri",
            percent: 60,
          ),
          SizedBox(height: 10,),
          GraphWidget(
            title: "VOC",
            percent: 35,
          ),
          SizedBox(height: 10,),
          GraphWidget(
            title: "Co2",
            percent: 65,
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget buildWeather() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoadingState) {
          return CircularProgressIndicator();
        } else if (state is WeatherFailedState) {
          return Text("Cannot load weather");
        } else {
          String city = (state as WeatherFetchedState).city;
          String icon = (state as WeatherFetchedState).icon;
          double temperature = (state as WeatherFetchedState).temperature;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                city,
                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    temperature.toStringAsFixed(1),
                    style: TextStyle(color: Colors.white, fontSize: 52, fontFamily: 'Montserrat'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "\u2103",
                    style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: 'Montserrat'),
                  ),
                ],
              ),
              icon != null
                  ? Image.network(
                "http://openweathermap.org/img/w/" + icon + ".png",
                width: 60,
                color: Colors.white,
              )
                  : BoxedIcon(
                WeatherIcons.sunrise,
                size: 40,
                color: Colors.white,
              ),
            ],
          );
        }
      },
    );
  }
}
