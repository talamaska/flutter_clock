// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

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
  Animation<double> _secondsAnimation;

  AnimationController _minutesController;
  Animation<double> _minutesAnimation;

  AnimationController _hoursController;
  Animation<double> _hoursAnimation;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    _secondsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _secondsController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _secondsController.reverse();
      }
    });

    _secondsAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: _secondsController,
        curve: Curves.linear,
      ),
    );

    _secondsAnimation.addListener(() {
      setState(() {});
    });

    _minutesController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 60000),
    );

    // _minutesController.addStatusListener((AnimationStatus status) {
    //   if (status == AnimationStatus.completed) {
    //     _minutesController.reverse();
    //   }
    // });

    _minutesAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: _minutesController,
        curve: Curves.linear,
      ),
    );

    _minutesAnimation.addListener(() {
      setState(() {});
    });

    _hoursController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3600000),
    );

    // _hoursController.addStatusListener((AnimationStatus status) {
    //   if (status == AnimationStatus.completed) {
    //     _hoursController.reverse();
    //   }
    // });

    _hoursAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: _hoursController,
        curve: Curves.linear,
      ),
    );

    _hoursAnimation.addListener(() {
      setState(() {});
    });

    // Set the initial values.

    _updateTime();
    _updateModel();
    setState(() {
      _now = DateTime.now();
      _minutesController.forward(from: (_now.second / 0.6) / 100);
      _hoursController.forward(from: (_now.minute / 0.6) / 100);
    });
    // _hoursController.forward(from: 0.0);
  }

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
      // _numbersController.forward(from: 0.0);

      // _minutesController.duration = Duration(seconds: 60) -
      //     Duration(seconds: _now.second) -
      //     Duration(milliseconds: _now.millisecond);

      // _hoursController.duration = Duration(minutes: 60) -
      //     Duration(minutes: _now.minute) -
      //     Duration(seconds: _now.second) -
      //     Duration(milliseconds: _now.millisecond);

      if (_now.second == 0) {
        _minutesController.forward(from: 0.0);
      }
      if (_now.second == 0 && _now.minute == 0) {
        _hoursController.forward(from: 0.0);
      }
      // if (_now.second == 0 && _now.minute == 0) {
      //   _hoursController.duration =
      //       Duration(seconds: 1) - Duration(milliseconds: _now.millisecond);
      // }

      // debugPrint('second ${_secondsController.duration}');
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
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
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF3C4043),
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
        child: Stack(
          children: [
            DrawnHandWithProgress(
              bodyColor: customTheme.accentColor,
              fillColor: customTheme.backgroundColor,
              thickness: 2,
              size: 1,
              handHeadRadius: 12,
              angleRadians: _now.second * radiansPerTick,
              value: _secondsAnimation.value,
              now: _now.second,
              text: '${_now.second}',
              scale: _scaleAnimation.value,
              opacity: _opacityAnimation.value,
            ),
            DrawnHandWithProgress(
              bodyColor: customTheme.accentColor,
              fillColor: customTheme.backgroundColor,
              thickness: 6,
              size: 0.93,
              handHeadRadius: 12,
              angleRadians: _now.minute * radiansPerTick,
              value: _minutesAnimation.value,
              now: _now.minute,
              text: '${_now.minute}',
              scale: 1.0,
              opacity: 1.0,
            ),
            DrawnHandWithProgress(
              bodyColor: customTheme.accentColor,
              fillColor: customTheme.backgroundColor,
              thickness: 10,
              size: 0.845,
              handHeadRadius: 16,
              angleRadians: _now.hour * radiansPerHour,
              value: _hoursAnimation.value,
              now: _now.hour * 5,
              text: '${_now.hour}',
              scale: 1.0,
              opacity: 1.0,
            ),
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
    );
  }
}
