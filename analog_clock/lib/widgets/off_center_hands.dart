import 'package:analog_clock/helpers.dart';
import 'package:analog_clock/widgets/off_center_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OffCenterCircleHands extends StatelessWidget {
  const OffCenterCircleHands({
    Key key,
    @required this.customTheme,
    @required DateTime now,
    @required AnimationController hoursController,
    @required AnimationController minutesController,
    @required AnimationController hours24Controller,
  })  : _now = now,
        _hoursController = hoursController,
        _minutesController = minutesController,
        _hours24Controller = hours24Controller,
        super(key: key);

  final ThemeData customTheme;
  final DateTime _now;
  final AnimationController _hoursController;
  final AnimationController _hours24Controller;
  final AnimationController _minutesController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        OffCenterCircle(
          borderColor: customTheme.accentColor.withOpacity(0.3),
          fillColor: customTheme.backgroundColor,
          thickness: 4,
          size: 0.70,
          offCenter: 0.08,
          handHeadRadius: 12,
          angleRadians: _now.minute * radiansPerTick,
          now: _now.minute,
          text: '${_now.minute}',
          progressController: _minutesController,
          rotationController: _hoursController,
        ),
        OffCenterCircle(
          isHourHand: true,
          borderColor: customTheme.accentColor.withOpacity(0.3),
          fillColor: customTheme.highlightColor.withOpacity(0.15),
          thickness: 4,
          size: 0.28,
          offCenter: 0.19,
          handHeadRadius: 16,
          angleRadians: _now.hour * radiansPerHour,
          now: _now.hour * 5,
          text: '${_now.hour}',
          progressController: _hoursController,
          rotationController: _hours24Controller,
        ),
      ],
    );
  }
}
