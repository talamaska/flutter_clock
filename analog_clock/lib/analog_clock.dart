// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/background_animated.dart';
import 'package:analog_clock/off_center_circle.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

// import 'package:analog_clock/drawn_hand.dart';
import 'package:analog_clock/drawn_hand_animated.dart';

// import 'drawn_hand_animated_minutes.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock>
    with TickerProviderStateMixin {
  DateTime _now = DateTime.now();
  Timer _timer;
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';

  AnimationController _secondsController;
  AnimationController _minutesController;
  AnimationController _hoursController;

  AnimationController _secondsNumbersController;
  AnimationController _minutesNumbersController;
  AnimationController _hoursNumbersController;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    _secondsNumbersController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _minutesNumbersController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _hoursNumbersController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _secondsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _secondsController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _secondsController.reverse();
      }
    });

    _minutesController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 60000),
    );

    _hoursController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3600000),
    );
    if (!mounted) return;
    _updateTime();
    _updateModel();
    setState(() {
      _now = DateTime.now();
      _minutesController.forward(from: (_now.second / 0.6) / 100);
      _hoursController.forward(from: (_now.minute / 0.6) / 100);
    });
    // _hoursController.forward(from: 0.0);
  }

  // @override
  // void setState(fn) {
  //   if (mounted) {
  //     super.setState(fn);
  //   }
  // }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    _secondsController.dispose();
    _minutesController.dispose();
    _hoursController.dispose();
    _secondsNumbersController.dispose();
    _minutesNumbersController.dispose();
    _hoursNumbersController.dispose();

    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _secondsController.duration =
          Duration(seconds: 1) - Duration(milliseconds: _now.millisecond);
      _secondsController.forward(from: 0.0);
      _secondsNumbersController.forward(from: 0.0);
      // _minutesController.forward(from: (_now.second / 0.6) / 100);
      // _hoursController.forward(from: (_now.minute / 0.6) / 100);

      _minutesController.duration = Duration(seconds: 60) -
          // Duration(minutes: _now.minute) -
          Duration(milliseconds: _now.millisecond);

      _hoursController.duration = Duration(minutes: 60) -
          // Duration(minutes: _now.minute) -
          Duration(milliseconds: _now.millisecond);

      if (_now.second == 0) {
        _minutesController.forward(from: 0.0);
        _minutesNumbersController.forward(from: 0.0);
      }
      if (_now.second == 0 && _now.minute == 0) {
        _hoursController.forward(from: 0.0);
        _hoursNumbersController.forward(from: 0.0);
      }

      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Color(0xFF4285F4),
            // Minute hand.
            highlightColor: Color(0xFF8AB4F8),
            // Second hand.
            accentColor: Color(0xFF669DF6),
            backgroundColor: Color(0xFFFFFFFF),
            errorColor: Color(0xFFF44336))
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF3C4043),
            errorColor: Colors.redAccent[400],
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
          Text(_location),
        ],
      ),
    );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        padding: EdgeInsets.all(5.0),
        child: Container(
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: customTheme.accentColor.withOpacity(0.2),
            border: Border.all(
              color: customTheme.accentColor,
              style: BorderStyle.solid,
              width: 3,
            ),
          ),
          child: Stack(
            children: [
              OffCenterCircle(
                borderColor: customTheme.accentColor,
                fillColor: customTheme.backgroundColor,
                thickness: 4,
                size: 0.70,
                offCenter: 0.1,
                handHeadRadius: 12,
                angleRadians: _now.minute * radiansPerTick,
                now: _now.minute,
                text: '${_now.minute}',
                numbersController: _minutesNumbersController,
                progressController: _minutesController,
              ),
              OffCenterCircle(
                borderColor: customTheme.accentColor,
                fillColor: customTheme.accentColor.withOpacity(0.2),
                thickness: 4,
                size: 0.28,
                offCenter: 0.19,
                handHeadRadius: 16,
                angleRadians: _now.hour * radiansPerHour,
                now: _now.hour * 5,
                text: '${_now.hour}',
                numbersController: _hoursNumbersController,
                progressController: _hoursController,
              ),
              // ClockFace(customTheme: customTheme),
              DrawnHandWithProgress(
                bodyColor: customTheme.accentColor,
                fillColor: customTheme.backgroundColor,
                textColor: customTheme.errorColor,
                thickness: 2,
                size: 1,
                handHeadRadius: 0.08,
                angleRadians: _now.second * radiansPerTick,
                now: _now.second,
                text: '${_now.second}',
                numbersController: _secondsNumbersController,
                progressController: _secondsController,
              ),
              DrawnHandWithProgress(
                bodyColor: customTheme.accentColor,
                fillColor: customTheme.backgroundColor,
                textColor: customTheme.errorColor,
                thickness: 4,
                size: 0.88,
                handHeadRadius: 0.09,
                angleRadians: _now.minute * radiansPerTick,
                now: _now.minute,
                text: '${_now.minute}',
                numbersController: _minutesNumbersController,
                progressController: _minutesController,
              ),
              DrawnHandWithProgress(
                bodyColor: customTheme.accentColor,
                fillColor: customTheme.backgroundColor,
                textColor: customTheme.errorColor,
                thickness: 6,
                size: 0.72,
                handHeadRadius: 0.12,
                angleRadians: _now.hour * radiansPerHour,
                now: _now.hour * 5,
                text: '${_now.hour}',
                numbersController: _hoursNumbersController,
                progressController: _hoursController,
              ),
              BackgroundAnimated(controller: _minutesController),
              Positioned(
                left: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: weatherInfo,
                ),
              ),
              Text('$time'),
            ],
          ),
        ),
      ),
    );
  }
}

class ClockFace extends StatelessWidget {
  const ClockFace({
    Key key,
    @required this.customTheme,
  }) : super(key: key);

  final ThemeData customTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            customTheme.backgroundColor,
            Colors.black12,
          ],
          center: Alignment(-0.6, 0.3),
          radius: 2,
          stops: [
            0.3,
            1,
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          gradient: RadialGradient(
            colors: [
              customTheme.backgroundColor,
              Colors.black12,
            ],
            center: Alignment(0.6, -0.3),
            radius: 2,
            stops: [
              0.3,
              1,
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(50.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                customTheme.backgroundColor,
                Colors.black12,
              ],
              center: Alignment(-0.6, 0.3),
              radius: 2,
              stops: [
                0.3,
                1,
              ],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              gradient: RadialGradient(
                colors: [
                  customTheme.backgroundColor,
                  Colors.black12,
                ],
                center: Alignment(0.3, -0.3),
                radius: 2,
                stops: [
                  0.3,
                  1,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
