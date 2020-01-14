// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:analog_clock/hand_progress_widget.dart';
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
    @required this.numbersController,
    @required this.progressController,
  })  : assert(bodyColor != null),
        assert(fillColor != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        assert(handHeadRadius != null),
        assert(now != null),
        assert(text != null),
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
  final String text;
  final int now;
  final AnimationController numbersController;
  final AnimationController progressController;

  @override
  Widget build(BuildContext context) {
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
              child: HandProgressWidget(
                color: bodyColor,
                circleColor: fillColor,
                thickness: thickness,
                handSize: size,
                handHeadRadius: handHeadRadius,
                now: now,
                text: text,
                value: value,
                numbersController: numbersController,
                progressController: progressController,
              )
              // CustomPaint(
              //   painter: HandProgress(
              //     color: bodyColor,
              //     circleColor: fillColor,
              //     thickness: thickness,
              //     handSize: size,
              //     handHeadRadius: handHeadRadius,
              //     value: value,
              //     now: now,
              //     text: text,
              //     scale: 1,
              //     opacity: 0,
              //   ),
              // ),
              ),
        ),
      ),
    );
  }
}
