import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as vm;

class HandProgressPainter extends CustomPainter {
  final Color color;
  final Color circleColor;
  final Color textColor;
  final double thickness;
  final double handSize;
  final double handHeadRadius;
  final double value;
  final double rotation;
  final bool isHourHand;
  final Paint progressPaint;
  final Paint innerCirclePaint;

  HandProgressPainter({
    @required this.color,
    @required this.circleColor,
    @required this.textColor,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
    @required this.value,
    @required this.rotation,
    this.isHourHand = false,
  })  : assert(color != null),
        assert(circleColor != null),
        assert(textColor != null),
        assert(thickness != null),
        assert(handHeadRadius != null),
        assert(handSize != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0),
        progressPaint = Paint()
          ..color = circleColor
          ..strokeWidth = thickness
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.butt,
        innerCirclePaint = Paint()
          ..color = circleColor
          ..strokeWidth = 1
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.butt;

  double getRadius(Size size, kRadius) {
    return (size.shortestSide / 2) * kRadius;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    canvas.translate(
      size.longestSide / 2,
      thickness +
          getRadius(size, handHeadRadius) +
          (1 - handSize) * size.shortestSide,
    );
    // if (isHourHand) {
    //   debugPrint('now $rotation');
    // }
    canvas.rotate(vm.radians(-rotation));

    final Rect rect = Rect.fromLTWH(
      -getRadius(size, handHeadRadius),
      -getRadius(size, handHeadRadius),
      getRadius(size, handHeadRadius) * 2,
      getRadius(size, handHeadRadius) * 2,
    );

    canvas.rotate(vm.radians(270));

    canvas.drawArc(
      rect,
      vm.radians(0),
      vm.radians(value),
      true,
      progressPaint,
    );

    canvas.translate(
      -size.longestSide / 2,
      -thickness +
          getRadius(size, handHeadRadius) +
          (1 - handSize) * size.shortestSide,
    );
    // canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(HandProgressPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.circleColor != circleColor ||
        oldDelegate.thickness != thickness ||
        oldDelegate.handSize != handSize ||
        oldDelegate.handHeadRadius != handHeadRadius ||
        oldDelegate.rotation != rotation ||
        oldDelegate.value != value;
  }
}
