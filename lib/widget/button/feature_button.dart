import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibelit/bloc/bloc.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';

class FeatureButton extends StatefulWidget {

  final String caption;
  final String asset;
  final VoidCallback onClick;

  FeatureButton({this.caption, this.asset, this.onClick});

  @override
  _FeatureButtonState createState() => _FeatureButtonState();
}

class _FeatureButtonState extends State<FeatureButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          child: Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: new BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: BlocBuilder<StatusBloc, StatusState>(
                  builder: (context, state) {
                    return state is StatusOnState ? IconCircleButton(
                      icon: Image.asset(widget.asset, width: 40, height: 40, color: Color(0xFFc0cbd6),),
                      size: 40,
                      padding: 20,
                      onClick: () => widget.onClick(),
                    ) : Container();
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6,),
        BlocBuilder<StatusBloc, StatusState>(
          builder: (context, state) {
            return Text(state is StatusOnState ? widget.caption : " ", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, fontFamily: 'Montserrat'),);
          },
        ),

      ],
    );
  }
}
