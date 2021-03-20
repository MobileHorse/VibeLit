import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibelit/bloc/bloc.dart';
import 'package:vibelit/config/constants.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/screen/on_off_screen.dart';
import 'package:vibelit/util/preference_helper.dart';
import 'package:vibelit/util/time_utils.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';

class OperationStopScreen extends StatefulWidget {
  @override
  _OperationStopScreenState createState() => _OperationStopScreenState();
}

class _OperationStopScreenState extends State<OperationStopScreen> {
  OperationBloc _operationBloc;

  @override
  void initState() {
    super.initState();
    _operationBloc = BlocProvider.of<OperationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OperationBloc, OperationState>(
      buildWhen: (previous, current) {
        return current is! OperationStoppedState;
      },
        builder: (context, state) => Scaffold(
          backgroundColor: Styles.bgYellow,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Container()),
                    IconCircleButton(
                      icon: Icon(
                        Icons.clear,
                        size: 24,
                        color: Colors.black,
                      ),
                      onClick: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      size: 24,
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Text(
                "PROGRAM\nUNDER WAY",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28, fontFamily: 'Montserrat'),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40,),
              Text(
                PreferenceHelper.getString(Params.operationMode) == Constants.Surface_Disinfection ? "please don\'t enter\nthe room" : "",
                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Montserrat'),
                textAlign: TextAlign.center,
              ),
              PreferenceHelper.getString(Params.operationMode) != Constants.Air_Purification ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 120,),
                  Text(
                    "Time remaining",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Montserrat'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10,),
                  BlocBuilder<OperationBloc, OperationState>(
                    builder: (context, state) {
                      if (state is OperationInProgressState) {
                        return TextButton(
                          child: Text(
                            "${TimeUtils.calculateRemainedTimeInMinutes()} min",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Montserrat'),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            backgroundColor: Colors.white.withOpacity(0.1),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
                          ),
                        );
                      } else return Container();
                    },
                  )
                ],
              ) : Container(),
              Expanded(child: Container()),
              TextButton(
                child: Text(
                  "Stop",
                  style: TextStyle(color: Colors.red, fontSize: 20, fontFamily: 'Montserrat'),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  backgroundColor: Colors.white.withOpacity(0.1),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
                ),
                onPressed: () {
                  _operationBloc.add(OperationStopEvent());
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OnOffScreen(),));
                },
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
        listener: (context, state) {
          if (state is OperationStoppedState) Navigator.pop(context);
        },);
  }
}
