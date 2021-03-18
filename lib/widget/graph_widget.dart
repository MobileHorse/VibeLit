import 'package:flutter/material.dart';
import 'package:vibelit/config/styles.dart';

import 'progress/progress_bar.dart';

class GraphWidget extends StatefulWidget {
  final String title;
  final double percent;

  GraphWidget({this.title, this.percent});

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontFamily: 'Montserrat'),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: 200,
          height: 28,
          child: Stack(
            children: [
              ProgressBar(
                percent: widget.percent,
                backgroundColor: Styles.bgGrey,
                progressColor: Styles.bgYellow,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${widget.percent.toString()} %",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
