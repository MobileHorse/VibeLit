import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';

class AirQualityBar extends StatefulWidget {

  final double width, percent, height;
  final VoidCallback onClick;

  AirQualityBar({this.width, this.percent, this.height, this.onClick});

  @override
  _AirQualityBarState createState() => _AirQualityBarState();
}

class _AirQualityBarState extends State<AirQualityBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Styles.bgGrey,
        borderRadius: BorderRadius.circular(widget.height / 2)
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: widget.width * widget.percent / 100,
              height: widget.height,
              decoration: BoxDecoration(
                  color: Color(0xFFa1c6f1),
                  borderRadius: BorderRadius.circular(widget.height / 2)
              ),)
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: widget.height,
              height: widget.height,
              decoration: new BoxDecoration(
                color: Color(0xFFbdbdbd),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconCircleButton(
              icon: Icon(Icons.add, size: widget.height*2/3,),
              padding: widget.height/6,
              size: widget.height,
              onClick: () => widget.onClick(),
            ),
          )
        ],
      ),
    );
  }
}
