import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:vibelit/bloc/bloc.dart';
import 'package:vibelit/config/constants.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/screen/menu_screen.dart';
import 'package:vibelit/screen/on_off_screen.dart';
import 'package:vibelit/screen/operation_stop_screen.dart';
import 'package:vibelit/screen/parameter_screen.dart';
import 'package:vibelit/util/preference_helper.dart';
import 'package:vibelit/util/time_utils.dart';
import 'package:vibelit/util/toasts.dart';
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
  Timer timer, bluetoothTimer;
  OperationBloc _operationBloc;
  DataBloc _dataBloc;
  BluetoothBloc _bluetoothBloc;

  @override
  void initState() {
    super.initState();
    _operationBloc = BlocProvider.of<OperationBloc>(context);
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _bluetoothBloc = BlocProvider.of<BluetoothBloc>(context);
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      _operationBloc.add(OperationStatusEvent());
      _dataBloc.add(DataLoadEvent());
      if (_bluetoothBloc.state is BluetoothConnectedState) {
        BluetoothConnection connection = (_bluetoothBloc.state as BluetoothConnectedState).connection;
        connection.input.listen((data) => _onDataReceived(data));
      }
    });
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
    ToastUtils.showInfoToast(context, "Message from MicroController: " + String.fromCharCodes(data));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataBloc, DataState>(
        listener: (context, state) {
          if (state is DataLoadFailedState) ToastUtils.showErrorToast(context, "Cannot communicate with Micro Controller. Please check connection and try again.");
        },
      child: Scaffold(
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
                                buildStatus(),
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
                                          builder: (context) => MenuScreen(),
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
                            child: BlocBuilder<OperationBloc, OperationState>(
                              builder: (context, state) {
                                if (state is OperationInProgressState)
                                  return buildOperation(state);
                                else if (state is OperationLoadingState)
                                  return Container();
                                else
                                  return buildWeather();
                              },
                            ))
                      ],
                    )),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildData(),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StopButton(
                              width: 80,
                              height: 80,
                              onClick: () {},
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

  Widget buildStatus() {
    return BlocBuilder<StatusBloc, StatusState>(
      builder: (context, state) {
        bool status = state is StatusOnState;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: new BoxDecoration(
                color: status ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              status ? "ON" : "OFF",
              style: TextStyle(fontSize: 10, color: Styles.primaryGrey),
            )
          ],
        );
      },
    );
  }

  Widget buildOperation(OperationInProgressState state) {
    String mode = state.mode;
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OperationStopScreen(),
              ));
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(10),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
        ),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Styles.bgYellow),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "PROGRAM\nUNDER WAY",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Montserrat'),
                textAlign: TextAlign.center,
              ),
              mode != Constants.Air_Purification
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Time remaining",
                          style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Montserrat'),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextButton(
                          child: Text(
                            "${TimeUtils.calculateRemainedTimeInMinutes()} min",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Montserrat'),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
                          ),
                        )
                      ],
                    )
                  : Container(width: 1,),
            ],
          ),
        ));
  }

  Widget buildData() {
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is DataLoadingState) {
          return CircularProgressIndicator();
        } else {
          String data = PreferenceHelper.getString(Params.sensorData);
          if (data.isEmpty)
            return Container();
          else
            return Column(
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
                  data.toUpperCase(),
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
            );
        }
      },
    );
  }
}
