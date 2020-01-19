import 'package:analog_clock/painters/numbers_painter.dart';
import 'package:flutter/material.dart';

class ClockNumbers extends StatelessWidget {
  const ClockNumbers({
    Key key,
    @required this.customTheme,
  }) : super(key: key);

  final ThemeData customTheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomPaint(
            key: key,
            painter: NumbersPainter(
              color: customTheme.accentColor,
              customTheme: customTheme,
            ),
          ),
        ),
      ),
    );
  }
}
