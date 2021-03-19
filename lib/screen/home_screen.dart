import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibelit/api/weather_api.dart';
import 'package:vibelit/bloc/weather_bloc/bloc.dart';
import 'package:vibelit/config/application.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/screen/air_purification_screen.dart';
import 'package:vibelit/screen/on_off_screen.dart';
import 'package:vibelit/screen/parameter_screen.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';
import 'package:vibelit/widget/button/phone_button.dart';
import 'package:vibelit/widget/button/stop_button.dart';
import 'package:vibelit/widget/progress/air_quality_bar.dart';
import 'package:vibelit/widget/progress/progress_bar.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryGrey,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffa0c7f3), Colors.purple],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/home.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 7 / 12,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
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
                                style: TextStyle(fontSize: 10, color: Styles.primaryGrey),
                              )
                            ],
                          ),
                          IconCircleButton(
                            icon: Icon(
                              Icons.menu,
                              size: 24,
                              color: Styles.primaryGrey,
                            ),
                            onClick: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OnOffScreen(),
                                  ));
                            },
                            size: 24,
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: buildWeather()
                  )
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mode selected",
                        style: TextStyle(color: Styles.primaryGrey, fontSize: 12, fontFamily: 'Montserrat'),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "ODOUR REMOUVAL",
                        style: TextStyle(color: Styles.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Montserrat'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Air quality",
                        style: TextStyle(color: Styles.primaryGrey, fontSize: 12, fontFamily: 'Montserrat'),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      AirQualityBar(
                        width: 200,
                        height: 28,
                        percent: 10,
                        onClick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParameterScreen(),
                              ));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "filter status",
                        style: TextStyle(color: Styles.primaryGrey, fontSize: 12, fontFamily: 'Montserrat'),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      ProgressBar(
                        width: 200,
                        height: 28,
                        percent: 30,
                        backgroundColor: Styles.bgGrey,
                        progressColor: Styles.bgYellow,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StopButton(
                        width: 80,
                        height: 80,
                        onClick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AirPurificationScreen(),
                              ));
                        },
                      ),
                      PhoneButton(
                        width: 80,
                        height: 80,
                        onClick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnOffScreen(),
                              ));
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              )),
            ],
          )
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
                  style: TextStyle(color: Styles.primaryGrey, fontSize: 16, fontFamily: 'Montserrat'),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      temperature.toStringAsFixed(1),
                      style: TextStyle(color: Styles.primaryGrey, fontSize: 52, fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "\u2103",
                      style: TextStyle(color: Styles.primaryGrey, fontSize: 36, fontFamily: 'Montserrat'),
                    ),
                  ],
                ),
                icon != null
                    ? Image.network(
                  "http://openweathermap.org/img/w/" + icon + ".png",
                  width: 60,
                  color: Styles.primaryGrey,
                )
                    : BoxedIcon(
                  WeatherIcons.sunrise,
                  size: 40,
                  color: Styles.primaryGrey,
                ),
              ],
            );
          }
        },
    );
  }
}
