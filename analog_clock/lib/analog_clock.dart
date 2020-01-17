// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/widgets/background_circles.dart';
import 'package:analog_clock/widgets/clock_hands.dart';
import 'package:analog_clock/widgets/clock_texts.dart';

import 'package:analog_clock/widgets/off_center_hands.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

  var _temperatureHigh = '';
  var _temperatureLow = '';
  var _condition = '';
  var _location = '';

  AnimationController _secondsController;
  AnimationController _minutesController;
  AnimationController _hoursController;
  AnimationController _24hoursController;

  // AnimationController _secondsNumbersController;
  // AnimationController _minutesNumbersController;
  // AnimationController _hoursNumbersController;

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

    _minutesController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );

    _hoursController = AnimationController(
      vsync: this,
      duration: Duration(minutes: 60),
    );

    _24hoursController = AnimationController(
      vsync: this,
      duration: Duration(hours: 12),
    );

    if (!mounted) return;
    _updateTime();
    _updateModel();
    setState(() {
      _now = DateTime.now();
      _minutesController.forward(from: (_now.second / 0.6) / 100);
      _hoursController.forward(from: (_now.minute / 0.6) / 100);
      _24hoursController.forward(from: (_now.hour * 8.3).abs() / 100);
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
    _24hoursController.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      debugPrint(
          '${widget.model.highString} - ${widget.model.lowString} ${widget.model.weatherString}');

      _temperatureHigh = '${widget.model.highString}';
      _temperatureLow = '${widget.model.lowString}';
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
      // _secondsNumbersController.forward(from: 0.0);
      // _minutesController.forward(from: (_now.second / 0.6) / 100);
      // _hoursController.forward(from: (_now.minute / 0.6) / 100);

      _minutesController.duration = Duration(seconds: 60) -
          // Duration(minutes: _now.minute) -
          Duration(milliseconds: _now.millisecond);

      _hoursController.duration = Duration(minutes: 60) -
          // Duration(minutes: _now.minute) -
          Duration(milliseconds: _now.millisecond);

      _24hoursController.duration = Duration(hours: 12) -
          // Duration(minutes: _now.minute) -
          Duration(milliseconds: _now.millisecond);

      if (_now.second == 0) {
        _minutesController.forward(from: 0.0);
      }
      if (_now.second == 0 && _now.minute == 0) {
        _hoursController.forward(from: 0.0);
      }

      if (_now.second == 0 && _now.minute == 0 && _now.hour == 12) {
        _24hoursController.forward(from: 0.0);
      }

      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('is24HourFormat ${widget.model.is24HourFormat}');
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final textTheme = Theme.of(context).textTheme;
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // texts, icons
            primaryColor: Color(0xFF4285F4),
            // offcenter circle background
            highlightColor: Color(0xFF8AB4F8),
            // hand body, progress fill, off center circles borders
            accentColor: Color(0xFF669DF6),
            backgroundColor: Color(0xFFFFFFFF),
            // hand numbers colors
            errorColor: Color(0xFF4285F4),
            textTheme: GoogleFonts.comfortaaTextTheme(textTheme),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF3C4043),
            errorColor: Colors.green,
            textTheme: GoogleFonts.comfortaaTextTheme(textTheme),
          );

    final time = DateFormat.Hms().format(DateTime.now());

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
              color: customTheme.highlightColor.withOpacity(0.15),
              border: Border.all(
                color: customTheme.accentColor.withOpacity(0.3),
                style: BorderStyle.solid,
                width: 3,
              ),
            ),
            child: Stack(
              children: <Widget>[
                BackgroundCircles(
                  minutesController: _minutesController,
                  customTheme: customTheme,
                ),
                OffCenterCircleHands(
                    customTheme: customTheme,
                    now: _now,
                    minutesController: _minutesController,
                    hoursController: _hoursController),
                ClockHands(
                  customTheme: customTheme,
                  now: _now,
                  is24HourFormat: widget.model.is24HourFormat,
                  hoursController: _hoursController,
                  hoursController24: _24hoursController,
                  minutesController: _minutesController,
                  secondsController: _secondsController,
                ),
                ClockTexts(
                  temperatureHigh: _temperatureHigh,
                  temperatureLow: _temperatureLow,
                  location: _location,
                  temperature: _temperature,
                  customTheme: customTheme,
                  condition: _condition,
                ),
              ],
            )),
      ),
    );
  }
}
