// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:analog_clock/progress_painer.dart';

import 'package:flutter/material.dart';

import 'hand.dart';
import 'hand_painter.dart';

/// A clock hand that is drawn with [CustomPainter]

class DrawnHandWithProgress extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  DrawnHandWithProgress({
    @required Color bodyColor,
    @required Color fillColor,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
    @required double handHeadRadius,
    @required this.now,
    @required this.text,
    @required this.value,
    @required this.scale,
    @required this.opacity,
  })  : assert(bodyColor != null),
        assert(fillColor != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        assert(handHeadRadius != null),
        assert(now != null),
        assert(text != null),
        assert(scale != null),
        assert(opacity != null),
        super(
          bodyColor: bodyColor,
          fillColor: fillColor,
          size: size,
          angleRadians: angleRadians,
          handHeadRadius: handHeadRadius,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;
  final double value;
  final double scale;
  final double opacity;
  final String text;
  final int now;

  @override
  Widget build(BuildContext context) {
    final HandProgressModel model = HandProgressModel(
      color: bodyColor,
      circleColor: fillColor,
      thickness: thickness,
      handSize: size,
      handHeadRadius: handHeadRadius,
      value: value,
      now: now,
      text: text,
    );

    return Center(
      child: SizedBox.expand(
        child: Transform.rotate(
          angle: angleRadians,
          child: CustomPaint(
            painter: HandPainter(
              color: bodyColor,
              thickness: thickness,
              handSize: size,
              handHeadRadius: handHeadRadius,
              value: value,
              now: now,
              text: text,
            ),
            child: CustomPaint(
              painter: HandProgress(
                color: bodyColor,
                circleColor: fillColor,
                thickness: thickness,
                handSize: size,
                handHeadRadius: handHeadRadius,
                value: value,
                now: now,
                text: text,
                scale: scale,
                opacity: opacity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HandProgressModel {
  final Color color;
  final Color circleColor;
  final double thickness;
  final double handSize;
  final double handHeadRadius;
  final double value;
  final String text;
  final int now;

  HandProgressModel({
    @required this.color,
    @required this.circleColor,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
    @required this.value,
    @required this.now,
    @required this.text,
  })  : assert(color != null),
        assert(circleColor != null),
        assert(thickness != null),
        assert(handHeadRadius != null),
        assert(handSize != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);
}

class HandProgressWidget extends StatefulWidget {
  final HandProgressModel model;

  // static const _secondTextStyle = TextStyle(
  //   color: Colors.red,
  //   fontSize: 10,
  //   fontWeight: FontWeight.bold,
  // );

  HandProgressWidget({
    @required this.model,
  }) : assert(model != null);

  @override
  _HandProgressWidgetState createState() => _HandProgressWidgetState();
}

class _HandProgressWidgetState extends State<HandProgressWidget>
    with TickerProviderStateMixin {
  HandProgressModel _model;
  AnimationController _numbersController;
  Animation<double> _scaleAnimation;
  Animation<double> _opacityAnimation;
  DateTime _now = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _model = widget.model;
    _numbersController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _numbersController,
        curve: Curves.easeInOut,
      ),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _numbersController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation.addListener(() {
      setState(() {});
    });
    _opacityAnimation.addListener(() {
      setState(() {});
    });

    _updateTime();
  }

  @override
  void dispose() {
    _numbersController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _numbersController.forward(from: 0.0);
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HandProgress(
        color: _model.color,
        circleColor: _model.circleColor,
        thickness: _model.thickness,
        handSize: _model.handSize,
        handHeadRadius: _model.handHeadRadius,
        value: _model.value,
        now: _model.now,
        text: _model.text,
        scale: _scaleAnimation.value,
        opacity: _opacityAnimation.value,
      ),
    );
  }
}
