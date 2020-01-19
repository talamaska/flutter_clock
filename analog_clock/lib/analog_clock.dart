// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/widgets/background_circles.dart';
import 'package:analog_clock/widgets/clock_hands.dart';
import 'package:analog_clock/widgets/clock_numbers.dart';
import 'package:analog_clock/widgets/clock_texts.dart';

import 'package:analog_clock/widgets/off_center_hands.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

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
  Timer _timerSecond;
  Timer _timerMinute;
  Timer _timerHour;
  Timer _timerHour24;
  var _temperature = '';

  var _temperatureHigh = '';
  var _temperatureLow = '';
  var _condition = '';
  var _location = '';

  AnimationController _secondsController;
  AnimationController _minutesController;
  AnimationController _hoursController;
  AnimationController _hours24Controller;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    _secondsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _minutesController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );

    _hoursController = AnimationController(
      vsync: this,
      duration: Duration(minutes: 60),
    );

    _hours24Controller = AnimationController(
      vsync: this,
      duration: Duration(hours: 24),
    );

    if (!mounted) return;
    _updateTimeSeconds();
    _updateTimeMinutes();
    _updateTimeHours();
    _updateTimeHours24();
    _updateModel();
    // setState(() {
    //   _now = DateTime.now();
    //   _minutesController.forward(from: (_now.second / 60));
    //   _hoursController.forward(from: (_now.minute / 60));
    //   _hours24Controller.forward(
    //       from:
    //           (_now.hour / 24 + _now.minute / 60 / 60 + _now.second / 60 / 60));
    // });
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
    _timerSecond?.cancel();
    _timerMinute?.cancel();
    _timerHour?.cancel();
    _timerHour24?.cancel();

    widget.model.removeListener(_updateModel);
    _secondsController.dispose();
    _minutesController.dispose();
    _hoursController.dispose();
    _hours24Controller.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      // debugPrint(
      //     '${widget.model.highString} - ${widget.model.lowString} ${widget.model.weatherString}');

      _temperatureHigh = '${widget.model.highString}';
      _temperatureLow = '${widget.model.lowString}';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTimeSeconds() {
    setState(() {
      _now = DateTime.now();
      _secondsController.duration =
          Duration(seconds: 1) - Duration(milliseconds: _now.millisecond);
      _secondsController.forward(from: 0.0);

      _timerSecond = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTimeSeconds,
      );
    });
  }

  void _updateTimeMinutes() {
    setState(() {
      _now = DateTime.now();
      _minutesController.duration =
          Duration(minutes: 1) - Duration(seconds: _now.second);
      //  -
      // Duration(milliseconds: _now.millisecond);
      // debugPrint('${_now.second} + ${_now.millisecond}');
      // final temp = (_now.second / 60) + _now.millisecond / 60000;
      // debugPrint('temp $temp,   ${_minutesController.duration.inSeconds}');
      _minutesController.forward(
          from: (_now.second / 60) + _now.millisecond / (60 * 1000));

      _timerMinute = Timer(
        Duration(minutes: 1) - Duration(seconds: _now.second),
        //  -
        // Duration(milliseconds: _now.millisecond),
        _updateTimeMinutes,
      );
    });
  }

  void _updateTimeHours() {
    setState(() {
      _now = DateTime.now();
      _hoursController.duration = Duration(hours: 1) -
          Duration(minutes: _now.minute) -
          Duration(seconds: _now.second);
      //  -
      // Duration(milliseconds: _now.millisecond);
      debugPrint('--- ${_hoursController.duration.inMinutes}');
      _hoursController.forward(from: (_now.minute / 60));

      _timerHour = Timer(
        Duration(hours: 1) -
            Duration(minutes: _now.minute) -
            Duration(seconds: _now.second),
        //  -
        // Duration(milliseconds: _now.millisecond),
        _updateTimeHours,
      );
    });
  }

  void _updateTimeHours24() {
    setState(() {
      _now = DateTime.now();
      _hours24Controller.duration = Duration(days: 1) -
          Duration(hours: _now.hour) -
          Duration(minutes: _now.minute) -
          Duration(seconds: _now.second);
      // -
      // Duration(milliseconds: _now.millisecond);
      _hours24Controller.forward(from: (_now.hour / 24));

      _timerHour24 = Timer(
        Duration(days: 1) -
            Duration(hours: _now.hour) -
            Duration(minutes: _now.minute) -
            Duration(seconds: _now.second),
        //  -
        // Duration(milliseconds: _now.millisecond),
        _updateTimeHours24,
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
            primaryColor: Color(0xFFaf0435),
            accentColor: Color(0xFFcc0033),
            highlightColor: Color(0xFFf9bb7d),
            cardColor: Color(0xFFffebc7),
            dividerColor: Color(0xFFc69a6d),
            errorColor: Color(0xFFcc0033), //text
            backgroundColor: Color(0xFFFFFFFF),
            splashColor: Color(0xFFDCBD93),
            hintColor: Color(0xFFFFFFFF),
            canvasColor: Color(0xFFf2e6da),
            buttonColor: Color(0xFF3fa9f5),
            textTheme: textTheme.apply(fontFamily: 'Comfortaa'),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFc92b1b),
            highlightColor: Color(0xFF282828),
            accentColor: Color(0xFFe1432b),
            cardColor: Color(0xFF333333),
            dividerColor: Color(0xFF6b6764),
            backgroundColor: Color(0xFF3C4043),
            canvasColor: Color(0xFF333333),
            splashColor: Color(0xFF282828),
            hintColor: Color(0xFF77726E),
            errorColor: Color(0xFFe1432b),
            buttonColor: Color(0xFF3fa9f5),
            textTheme: textTheme.apply(fontFamily: 'Comfortaa'),
          );

    final time = DateFormat.Hms().format(DateTime.now());
    // debugPrint('theme customTheme ${customTheme.textTheme.body1.fontFamily}');
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        // color: customTheme.backgroundColor,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            customTheme.splashColor,
            customTheme.hintColor,
            customTheme.splashColor,
          ], stops: [
            0,
            0.5,
            1,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Container(
            padding: EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: customTheme.highlightColor,
              // border: Border.all(
              //   color: customTheme.accentColor,
              //   style: BorderStyle.solid,
              //   width: 3,
              // ),
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
                  hoursController: _hoursController,
                  hours24Controller: _hours24Controller,
                ),
                ClockNumbers(customTheme: customTheme),
                ClockHands(
                  customTheme: customTheme,
                  now: _now,
                  is24HourFormat: widget.model.is24HourFormat,
                  hoursController: _hoursController,
                  hours24Controller: _hours24Controller,
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
