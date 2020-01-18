// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:analog_clock/widgets/hand_body.dart';
import 'package:analog_clock/widgets/hand_progress.dart';
import 'package:flutter/material.dart';
import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]

class DrawnHandWithProgress extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const DrawnHandWithProgress({
    @required Color bodyColor,
    @required Color fillColor,
    @required double size,
    @required double angleRadians,
    @required double handHeadRadius,
    @required this.textColor,
    @required this.thickness,
    @required this.now,
    @required this.text,
    @required this.progressController,
    @required this.fullRotationController,
    this.isHourHand = false,
  })  : assert(bodyColor != null),
        assert(fillColor != null),
        assert(size != null),
        assert(angleRadians != null),
        assert(handHeadRadius != null),
        assert(textColor != null),
        assert(thickness != null),
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
  final Color textColor;
  final String text;
  final int now;
  final bool isHourHand;
  final AnimationController progressController;
  final AnimationController fullRotationController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: HandBody(
          isHourHand: isHourHand,
          bodyColor: bodyColor,
          fillColor: fillColor,
          thickness: thickness,
          size: size,
          angleRadians: angleRadians,
          handHeadRadius: handHeadRadius,
          now: now,
          text: text,
          progressController: progressController,
          fullRotationController: fullRotationController,
          child: HandProgress(
            color: bodyColor,
            circleColor: fillColor,
            textColor: textColor,
            thickness: thickness,
            handSize: size,
            handHeadRadius: handHeadRadius,
            now: now,
            text: text,
            progressController: progressController,
            rotationController: fullRotationController,
          ),
        ),
      ),
    );

    return Center(
      child: SizedBox.expand(
        child: Transform.rotate(
          angle: angleRadians,
          child: HandBody(
            bodyColor: bodyColor,
            fillColor: fillColor,
            thickness: thickness,
            size: size,
            angleRadians: angleRadians,
            handHeadRadius: handHeadRadius,
            now: now,
            text: text,
            progressController: progressController,
            child: HandProgress(
              color: bodyColor,
              circleColor: fillColor,
              textColor: textColor,
              thickness: thickness,
              handSize: size,
              handHeadRadius: handHeadRadius,
              now: now,
              text: text,
              progressController: progressController,
            ),
          ),
        ),
      ),
    );
  }
}
