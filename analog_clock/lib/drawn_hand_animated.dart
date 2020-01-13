// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vm;
import 'package:flutter/material.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHandAnimated extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  DrawnHandAnimated({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
    @required double handHeadRadius,
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
  final double value;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Center(
      child: SizedBox.expand(
        child: Transform.rotate(
          angle: 0,
          child: CustomPaint(
            painter: SecondsPainterAnimated(
              color: color,
              thickness: thickness,
              handSize: size,
              handHeadRadius: handHeadRadius,
              value: value,
            ),
            child: CustomPaint(
              painter: SecondsPainterAnimatedProgress(
                color: color,
                thickness: thickness,
                handSize: size,
                handHeadRadius: handHeadRadius,
                value: value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SecondsPainterAnimated extends CustomPainter {
  Color color;
  double thickness;
  double handSize;
  double handHeadRadius;
  double value;

  SecondsPainterAnimated({
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

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    final innerCirclePaint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final endHand = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final circlePaint = Paint()
      ..color = color
      ..strokeWidth = 0;

    // hand body
    // first part of the hand
    final Path path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(size.longestSide / 2,
        (1 - handSize) * size.shortestSide + thickness + 3 * handHeadRadius);
    canvas.drawPath(path, linePaint);

    //second part of the hand
    final Path path2 = Path();
    path2.moveTo(size.longestSide / 2,
        (1 - handSize) * size.shortestSide + thickness + handHeadRadius);
    path2.lineTo(
        size.longestSide / 2, (1 - handSize) * size.shortestSide + thickness);
    canvas.drawPath(path2, endHand);

    // hand start
    canvas.drawCircle(
      center,
      3,
      circlePaint,
    );

    // // hand head
    final Rect rect = Rect.fromLTWH(
      size.longestSide / 2 - handHeadRadius,
      (1 - handSize) * size.shortestSide + thickness + handHeadRadius,
      handHeadRadius * 2,
      handHeadRadius * 2,
    );

    final Path circle = Path()..addOval(rect);
    canvas.drawPath(circle, innerCirclePaint);

    // canvas.drawArc(
    //   rect,
    //   vm.radians(0),
    //   vm.radians(value),
    //   true,
    //   progressPaint,
    // );

    // final textStyle = TextStyle(
    //   color: Colors.black,
    //   fontSize: 30,
    // );
    // final textSpan = TextSpan(
    //   text: '${second} - ${animation}',
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
  bool shouldRepaint(SecondsPainterAnimated oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.handSize != handSize ||
        oldDelegate.handHeadRadius != handHeadRadius ||
        oldDelegate.value != value;
  }
}

class SecondsPainterAnimatedProgress extends CustomPainter {
  Color color;
  double thickness;
  double handSize;
  double handHeadRadius;
  double value;

  SecondsPainterAnimatedProgress({
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
    canvas.save();
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    final innerCirclePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt;

    // hand head
    final Rect rect = Rect.fromLTWH(
      size.longestSide / 2 - handHeadRadius,
      (1 - handSize) * size.shortestSide + thickness + handHeadRadius,
      handHeadRadius * 2,
      handHeadRadius * 2,
    );
    // final double test = size.shortestSide / 2 - thickness - handHeadRadius;
    // debugPrint('$test');
    canvas.translate(size.longestSide / 2, thickness + handHeadRadius * 2);
    canvas.rotate(vm.radians(90));

    final Path circle = Path()..addOval(rect);
    canvas.drawPath(circle, innerCirclePaint);

    canvas.drawArc(
      rect,
      vm.radians(0),
      vm.radians(value),
      true,
      progressPaint,
    );

    canvas.translate(
        -(size.longestSide / 2), -(thickness + handHeadRadius * 2));

    canvas.restore();
  }

  @override
  bool shouldRepaint(SecondsPainterAnimatedProgress oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.handSize != handSize ||
        oldDelegate.handHeadRadius != handHeadRadius ||
        oldDelegate.value != value;
  }
}
