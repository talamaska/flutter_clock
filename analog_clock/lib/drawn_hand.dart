// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const DrawnHand({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
    @required double handHeadRadius,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        assert(handHeadRadius != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
          handHeadRadius: handHeadRadius,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: Transform.rotate(
          angle: angleRadians,
          child: CustomPaint(
            painter: SecondsPainter(
              color: color,
              thickness: thickness,
              handSize: size,
              handHeadRadius: handHeadRadius,
            ),
          ),
        ),
      ),
    );
  }
}

class SecondsPainter extends CustomPainter {
  Color color;
  double thickness;
  double handSize;
  double handHeadRadius;

  SecondsPainter({
    @required this.color,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
  })  : assert(color != null),
        assert(thickness != null),
        assert(handHeadRadius != null),
        assert(handSize != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final length = size.shortestSide * 0.5 * handSize - thickness;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final circlePaint = Paint()
      ..color = color
      ..strokeWidth = 0;

    // hand start
    canvas.drawCircle(
      center,
      3,
      circlePaint,
    );

    // hand body
    canvas.drawLine(
      center,
      Offset(size.longestSide / 2, size.shortestSide * 0.5 - length),
      linePaint,
    );

    // hand head
    canvas.drawCircle(
      Offset(size.longestSide / 2, size.shortestSide * 0.5 - length + 15),
      handHeadRadius,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(SecondsPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.handSize != handSize ||
        oldDelegate.handHeadRadius != handHeadRadius;
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final length = size.shortestSide * 0.5 * handSize;
    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(center, position, linePaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
