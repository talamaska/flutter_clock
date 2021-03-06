import 'package:analog_clock/utils/helpers.dart';
import 'package:analog_clock/widgets/drawn_hand_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';

class ClockHands extends StatelessWidget {
  const ClockHands({
    Key key,
    @required this.customTheme,
    @required DateTime now,
    @required bool is24HourFormat,
    @required AnimationController hoursController,
    @required AnimationController hours24Controller,
    @required AnimationController minutesController,
    @required AnimationController secondsController,
  })  : _now = now,
        _hoursController = hoursController,
        _hours24Controller = hours24Controller,
        _is24HourFormat = is24HourFormat,
        _minutesController = minutesController,
        _secondsController = secondsController,
        super(key: key);

  final bool _is24HourFormat;
  final ThemeData customTheme;
  final DateTime _now;
  final AnimationController _hoursController;
  final AnimationController _hours24Controller;
  final AnimationController _minutesController;
  final AnimationController _secondsController;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hms().format(DateTime.now());
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'The current time is $time',
      ),
      child: Stack(
        children: <Widget>[
          DrawnHandWithProgress(
            bodyColor: customTheme.primaryColor,
            fillColor: customTheme.accentColor,
            textColor: customTheme.errorColor,
            thickness: 2,
            size: 0.986,
            handHeadRadius: 0.07,
            angleRadians: _now.second * radiansPerTick,
            now: _now.second,
            text: '${_now.second}',
            progressController: _secondsController,
            fullRotationController: _minutesController,
          ),
          DrawnHandWithProgress(
            bodyColor: customTheme.primaryColor,
            fillColor: customTheme.accentColor,
            textColor: customTheme.errorColor,
            thickness: 2.2,
            size: 0.87,
            handHeadRadius: 0.088,
            angleRadians: _now.minute * radiansPerTick,
            now: _now.minute,
            text: '${_now.minute}',
            progressController: _minutesController,
            fullRotationController: _hoursController,
          ),
          DrawnHandWithProgress(
            isHourHand: true,
            bodyColor: customTheme.primaryColor,
            fillColor: customTheme.accentColor,
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
            fullRotationController: _hours24Controller,
          ),
        ],
      ),
    );
  }
}
