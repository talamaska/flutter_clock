import 'package:analog_clock/helpers.dart';
import 'package:analog_clock/widgets/drawn_hand_animated.dart';
import 'package:flutter/material.dart';

class ClockHands extends StatelessWidget {
  const ClockHands({
    Key key,
    @required this.customTheme,
    @required DateTime now,
    @required bool is24HourFormat,
    @required AnimationController hoursController,
    @required AnimationController hoursController24,
    @required AnimationController minutesController,
    @required AnimationController secondsController,
  })  : _now = now,
        _hoursController = hoursController,
        _24hoursController = hoursController24,
        _is24HourFormat = is24HourFormat,
        _minutesController = minutesController,
        _secondsController = secondsController,
        super(key: key);

  final bool _is24HourFormat;
  final ThemeData customTheme;
  final DateTime _now;
  final AnimationController _hoursController;
  final AnimationController _24hoursController;
  final AnimationController _minutesController;
  final AnimationController _secondsController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DrawnHandWithProgress(
          bodyColor: customTheme.accentColor,
          fillColor: customTheme.backgroundColor,
          textColor: customTheme.errorColor,
          thickness: 2,
          size: 1,
          handHeadRadius: 0.07,
          angleRadians: _now.second * radiansPerTick,
          now: _now.second,
          text: '${_now.second}',
          progressController: _secondsController,
          fullRotationController: _minutesController,
        ),
        DrawnHandWithProgress(
          bodyColor: customTheme.accentColor,
          fillColor: customTheme.backgroundColor,
          textColor: customTheme.errorColor,
          thickness: 2.2,
          size: 0.88,
          handHeadRadius: 0.088,
          angleRadians: _now.minute * radiansPerTick,
          now: _now.minute,
          text: '${_now.minute}',
          progressController: _minutesController,
          fullRotationController: _hoursController,
        ),
        DrawnHandWithProgress(
          bodyColor: customTheme.accentColor,
          fillColor: customTheme.backgroundColor,
          textColor: customTheme.errorColor,
          thickness: 3,
          size: 0.72,
          handHeadRadius: 0.12,
          angleRadians: _now.hour * radiansPerHour,
          now: _now.hour * 5,
          text: _is24HourFormat
              ? '${_now.hour}'
              : _now.hour > 12 ? '${_now.hour - 12}' : '${_now.hour}',
          progressController: _hoursController,
          fullRotationController: _24hoursController,
        ),
      ],
    );
  }
}
