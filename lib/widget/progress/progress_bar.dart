import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final double width, height, percent;
  final Color backgroundColor, progressColor;

  ProgressBar({this.width = 200, this.height = 28, this.percent, this.backgroundColor, this.progressColor});

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    print("Percent: ${widget.percent}");
    print("width: ${widget.width}");
    print("progress: ${widget.width * widget.percent / 100}");
    return Stack(
      children: [
        Container(width: widget.width, height: widget.height, decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(widget.height / 2))),
        Container(
          width: widget.width * widget.percent / 100,
          height: widget.height,
          decoration: BoxDecoration(color: widget.progressColor, borderRadius: BorderRadius.circular(widget.height / 2)),
        ),
      ],
    );
  }
}
