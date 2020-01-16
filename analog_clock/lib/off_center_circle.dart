// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:analog_clock/hand_body_circle.dart';
import 'package:flutter/material.dart';
import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]

class OffCenterCircle extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const OffCenterCircle({
    @required Color borderColor,
    @required Color fillColor,
    @required double size,
    @required double angleRadians,
    @required double handHeadRadius,
    @required this.offCenter,
    @required this.thickness,
    @required this.now,
    @required this.text,
    // @required this.value,
    @required this.numbersController,
    @required this.progressController,
  })  : assert(borderColor != null),
        assert(fillColor != null),
        assert(thickness != null),
        assert(size != null),
        assert(offCenter != null),
        assert(angleRadians != null),
        assert(handHeadRadius != null),
        assert(now != null),
        assert(text != null),
        super(
          bodyColor: borderColor,
          fillColor: fillColor,
          size: size,
          angleRadians: angleRadians,
          handHeadRadius: handHeadRadius,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double offCenter;
  final double thickness;
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
          child: HandBodyCircle(
            borderColor: bodyColor,
            fillColor: fillColor,
            thickness: thickness,
            size: size,
            offCenter: offCenter,
            angleRadians: angleRadians,
            handHeadRadius: handHeadRadius,
            now: now,
            text: text,
            numbersController: numbersController,
            progressController: progressController,
          ),
        ),
      ),
    );
  }
}
