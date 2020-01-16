import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HandPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double handSize;
  final double handHeadRadius;
  final double value;
  final String text;
  final int now;

  HandPainter({
    @required this.color,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
    @required this.value,
    @required this.now,
    @required this.text,
  })  : assert(color != null),
        assert(thickness != null),
        assert(handHeadRadius != null),
        assert(handSize != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double getRadius(Size size, kRadius) {
    return (size.shortestSide / 2) * kRadius;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // final shadow = BoxShadow(
    //   blurRadius: 5,
    //   color: Colors.black12,
    //   offset: Offset(2, 2),
    //   spreadRadius: 1,
    // );
    // final paintS = shadow.toPaint();
    // canvas.drawPaint(paintS);

    final center = (Offset.zero & size).center;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final innerCirclePaint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final innerCirclePaint2 = Paint()
      ..color = Colors.white
      ..strokeWidth = thickness
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt;

    final endHand = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final circlePaint = Paint()
      ..color = color
      ..strokeWidth = 0;

    // final centralAsixPaint = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.fill
    //   ..strokeWidth = 0;

    // hand body
    // first part of the hand
    // final Path path = Path();
    // path.moveTo(center.dx, center.dy);
    // path.lineTo(size.longestSide / 2,
    //     (1 - handSize) * size.shortestSide + thickness + 3 * handHeadRadius);
    // canvas.drawPath(path, linePaint);

    final Path path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(
        size.longestSide / 2,
        (1 - handSize) * size.shortestSide +
            thickness +
            2 * getRadius(size, handHeadRadius));
    // canvas.drawShadow(path, Colors.black, 10.0, true);
    canvas.drawPath(path, linePaint);

    //second part of the hand
    // final Path path2 = Path();
    // path2.moveTo(size.longestSide / 2,
    //     (1 - handSize) * size.shortestSide + thickness + handHeadRadius);
    // path2.lineTo(
    //     size.longestSide / 2, (1 - handSize) * size.shortestSide + thickness);
    // canvas.drawPath(path2, endHand);

    // hand start

    final Rect rect1 = Rect.fromCircle(center: center, radius: thickness);
    final Path circle1 = Path()..addOval(rect1);
    // canvas.drawShadow(circle1, Colors.black, 5.0, true);
    canvas.drawPath(circle1, circlePaint);
    // canvas.drawCircle(
    //   center,
    //   2,
    //   centralAsixPaint,
    // );

    final Rect rect = Rect.fromLTWH(
      size.longestSide / 2 - getRadius(size, handHeadRadius) - thickness / 2,
      (1 - handSize) * size.shortestSide + thickness / 2,
      getRadius(size, handHeadRadius) * 2 + thickness,
      getRadius(size, handHeadRadius) * 2 + thickness,
    );

    final Path circle = Path()..addOval(rect);
    // canvas.drawShadow(circle, Colors.black, 5.0, true);
    // canvas.drawPath(circle, innerCirclePaint2);
    canvas.drawPath(circle, innerCirclePaint);
  }

  @override
  bool shouldRepaint(HandPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.value != value ||
        oldDelegate.text != text ||
        oldDelegate.now != now ||
        oldDelegate.handSize != handSize ||
        oldDelegate.handHeadRadius != handHeadRadius;
  }
}
