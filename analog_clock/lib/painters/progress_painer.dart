import 'package:flutter/material.dart' show Colors;
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

  final Paint progressPaint;
  final Paint innerCirclePaint;
  final String text;
  final int now;

  HandProgressPainter({
    @required this.color,
    @required this.circleColor,
    @required this.textColor,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
    @required this.value,
    @required this.now,
    @required this.text,
    // @required this.scale,
    // @required this.opacity,
  })  : assert(color != null),
        assert(circleColor != null),
        assert(textColor != null),
        assert(thickness != null),
        assert(handHeadRadius != null),
        assert(handSize != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0),
        // assert(scale != null),
        // assert(opacity != null),

        progressPaint = Paint()
          ..color = color
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
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: getRadius(size, handHeadRadius) * 2 * 0.7,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    canvas.save();

    canvas.translate(
      size.longestSide / 2,
      thickness +
          getRadius(size, handHeadRadius) +
          (1 - handSize) * size.shortestSide,
    );
    canvas.rotate(-now * vm.radians(360 / 60));

    final Rect rect = Rect.fromLTWH(
      -getRadius(size, handHeadRadius),
      -getRadius(size, handHeadRadius),
      getRadius(size, handHeadRadius) * 2,
      getRadius(size, handHeadRadius) * 2,
    );

    final Path circle = Path()..addOval(rect);
    canvas.drawPath(circle, innerCirclePaint);

    // hand head
    textPainter.layout(
      minWidth: getRadius(size, handHeadRadius) * 2,
      maxWidth: getRadius(size, handHeadRadius) * 2,
    );

    final offset = Offset(
      -getRadius(size, handHeadRadius),
      -getRadius(size, handHeadRadius) + getRadius(size, handHeadRadius) * 0.2,
    );
    textPainter.paint(canvas, offset);

    canvas.rotate(vm.radians(270));

    canvas.drawArc(
      rect,
      vm.radians(0),
      vm.radians(value),
      true,
      progressPaint,
    );
    canvas.saveLayer(null, Paint()..blendMode = BlendMode.multiply);
    canvas.rotate(vm.radians(-270));
    textPainter.paint(canvas, offset);
    canvas.rotate(vm.radians(270));

    canvas.translate(
      -size.longestSide / 2,
      -thickness +
          getRadius(size, handHeadRadius) +
          (1 - handSize) * size.shortestSide,
    );
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(HandProgressPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.circleColor != circleColor ||
        oldDelegate.thickness != thickness ||
        oldDelegate.handSize != handSize ||
        oldDelegate.handHeadRadius != handHeadRadius ||
        oldDelegate.text != text ||
        oldDelegate.value != value;
  }
}
