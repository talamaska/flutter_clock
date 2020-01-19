import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HandCirclePainter extends CustomPainter {
  final Color borderColor;
  final Color fillColor;
  final double thickness;
  final double handSize;
  final double offCenter;

  HandCirclePainter({
    @required this.borderColor,
    @required this.fillColor,
    @required this.handSize,
    @required this.offCenter,
    @required this.thickness,
  })  : assert(borderColor != null),
        assert(fillColor != null),
        assert(thickness != null),
        assert(offCenter != null),
        assert(handSize != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double getRadius(Size size, kRadius) {
    return (size.shortestSide / 2) * kRadius;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;

    final linePaint = Paint()
      ..color = borderColor.withOpacity(0)
      ..strokeWidth = 0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;
    final circlePaint = Paint()
      ..color = fillColor
      ..strokeWidth = 0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt;

    canvas.drawCircle(
      Offset(center.dx, center.dy - offCenter * size.shortestSide / 2),
      handSize * size.shortestSide / 2,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(center.dx, center.dy - offCenter * size.shortestSide / 2),
      handSize * size.shortestSide / 2,
      linePaint,
    );
  }

  @override
  bool shouldRepaint(HandCirclePainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.thickness != thickness ||
        oldDelegate.handSize != handSize;
  }
}
