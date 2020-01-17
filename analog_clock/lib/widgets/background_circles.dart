import 'package:analog_clock/widgets/background_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BackgroundCircles extends StatelessWidget {
  const BackgroundCircles({
    Key key,
    @required AnimationController minutesController,
    @required this.customTheme,
  })  : _minutesController = minutesController,
        super(key: key);

  final AnimationController _minutesController;
  final ThemeData customTheme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BackgroundCircle(
          controller: _minutesController,
          color: customTheme.primaryColor.withOpacity(0.15),
          circleOffset: Offset(0.95, 0),
          rotationOffset: Offset(1.05, 0.5),
          radius: 0.26,
        ),
        BackgroundCircle(
          controller: _minutesController,
          color: customTheme.primaryColor.withOpacity(0.15),
          circleOffset: Offset(0.95, 1),
          rotationOffset: Offset(1, 1),
          radius: 0.24,
        ),
        BackgroundCircle(
          controller: _minutesController,
          color: customTheme.primaryColor.withOpacity(0.15),
          circleOffset: Offset(0.05, 1.2),
          rotationOffset: Offset(0, 1),
          radius: 0.42,
        ),
        BackgroundCircle(
          controller: _minutesController,
          color: customTheme.primaryColor.withOpacity(0.15),
          circleOffset: Offset(0, 0.09),
          rotationOffset: Offset(-0.05, 0.1),
          radius: 0.40,
        ),
      ],
    );
  }
}
