import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as vm;

class HandProgress extends CustomPainter {
  final Color color;
  final Color circleColor;
  final double thickness;
  final double handSize;
  final double handHeadRadius;
  final double value;

  final TextPainter textPainter;
  final Paint progressPaint;
  final Paint innerCirclePaint;
  final String text;
  final int now;
  final double scale;
  final double opacity;
  // static const _secondTextStyle = TextStyle(
  //   color: Colors.red,
  //   fontSize: 10,
  //   fontWeight: FontWeight.bold,
  // );

  HandProgress({
    @required this.color,
    @required this.circleColor,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
    @required this.value,
    @required this.now,
    @required this.text,
    @required this.scale,
    @required this.opacity,
  })  : assert(color != null),
        assert(circleColor != null),
        assert(thickness != null),
        assert(handHeadRadius != null),
        assert(handSize != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0),
        assert(scale != null),
        assert(opacity != null),
        textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              color: Colors.red,
              fontSize: handHeadRadius * 2 * 0.6,
              fontWeight: FontWeight.bold,
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        progressPaint = Paint()
          ..color = color
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.butt,
        innerCirclePaint = Paint()
          ..color = circleColor
          ..strokeWidth = 1
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.butt;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final TextPainter textPainter2 = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.red.withOpacity(opacity),
          fontSize: handHeadRadius * 2 * 0.6 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // debugPrint('$test');
    // canvas.translate(size.longestSide / 2, thickness + handHeadRadius * 2);
    canvas.translate(
      size.longestSide / 2,
      thickness + handHeadRadius + (1 - handSize) * size.shortestSide,
    );
    canvas.rotate(-now * vm.radians(360 / 60));

    final Rect rect = Rect.fromLTWH(
      -handHeadRadius,
      -handHeadRadius,
      handHeadRadius * 2,
      handHeadRadius * 2,
    );

    final Path circle = Path()..addOval(rect);
    canvas.drawPath(circle, innerCirclePaint);

    // hand head
    textPainter.layout(
      minWidth: handHeadRadius * 2,
      maxWidth: handHeadRadius * 2,
    );

    final offset = Offset(
      -handHeadRadius,
      -handHeadRadius + handHeadRadius * 0.3,
    );
    textPainter.paint(canvas, offset);

    textPainter2.layout(
      minWidth: size.width,
      maxWidth: size.width,
    );

    final offset2 = Offset(
      -size.longestSide / 2,
      (-handHeadRadius + handHeadRadius * 0.3) * scale,
    );
    textPainter2.paint(canvas, offset2);

    canvas.rotate(vm.radians(270));

    // canvas.saveLayer(null, Paint()..blendMode = BlendMode.multiply);

    canvas.drawArc(
      rect,
      vm.radians(0),
      vm.radians(value),
      true,
      progressPaint,
    );
    // canvas.translate(size.longestSide / 2, thickness + handHeadRadius * 2);
    canvas.translate(
      -size.longestSide / 2,
      -thickness + handHeadRadius + (1 - handSize) * size.shortestSide,
    );
    // canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(HandProgress oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.handSize != handSize ||
        oldDelegate.handHeadRadius != handHeadRadius ||
        oldDelegate.value != value;
  }
}
