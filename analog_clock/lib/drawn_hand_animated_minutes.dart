// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vm;

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHandAnimatedMinutes extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  DrawnHandAnimatedMinutes({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
    @required double handHeadRadius,
    this.second,
    this.value,
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
  final int second;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: Transform.rotate(
          angle: angleRadians,
          child: CustomPaint(
            painter: SecondsPainterAnimatedMinutes(
              color: color,
              thickness: thickness,
              handSize: size,
              handHeadRadius: handHeadRadius,
              value: value,
            ),
          ),
        ),
      ),
    );
  }
}

class SecondsPainterAnimatedMinutes extends CustomPainter {
  Color color;
  double thickness;
  double handSize;
  double handHeadRadius;
  double value;

  SecondsPainterAnimatedMinutes({
    @required this.color,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
    @required this.value,
  })  : assert(color != null),
        assert(thickness != null),
        assert(handHeadRadius != null),
        assert(handSize != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.rotate(Angle.fromDegrees(-90).radians);
    final center = (Offset.zero & size).center;
    final length = size.shortestSide * 0.5 * handSize - thickness;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    final innerCirclePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.butt;

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
    final Rect rect = Rect.fromLTWH(
      size.longestSide / 2 - handHeadRadius,
      size.shortestSide * 0.5 - length + handHeadRadius,
      handHeadRadius * 2,
      handHeadRadius * 2,
    );

    final Path circle = Path()..addOval(rect);
    canvas.drawPath(circle, innerCirclePaint);

    final circleBorder = CircleBorder(
      side: BorderSide(
        color: color,
        style: BorderStyle.solid,
        width: 1,
      ),
    );

    circleBorder.paint(canvas, rect);

    canvas.drawArc(
      rect,
      vm.radians(0),
      vm.radians(value),
      true,
      progressPaint,
    );

    // final textStyle = TextStyle(
    //   color: Colors.black,
    //   fontSize: 30,
    // );
    // final textSpan = TextSpan(
    //   text: '${value}',
    //   style: textStyle,
    // );
    // final textPainter = TextPainter(
    //   text: textSpan,
    //   textDirection: TextDirection.ltr,
    // );
    // textPainter.layout(
    //   minWidth: 0,
    //   maxWidth: size.width,
    // );
    // final offset = Offset(100, 0);
    // textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(SecondsPainterAnimatedMinutes oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.handSize != handSize ||
        oldDelegate.handHeadRadius != handHeadRadius ||
        oldDelegate.value != value;
  }
}
