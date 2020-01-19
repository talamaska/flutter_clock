import 'package:flutter/material.dart';

class NumbersPainter extends CustomPainter {
  final Color color;
  final ThemeData customTheme;

  NumbersPainter({
    Key key,
    @required this.customTheme,
    @required this.color,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final TextStyle textStyle = customTheme.textTheme.body2.copyWith(
      color: customTheme.accentColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final textPainter3 = TextPainter(
      text: TextSpan(
        text: '3',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter3.layout(
      minWidth: 16,
      maxWidth: size.width,
    );
    textPainter3.paint(
      canvas,
      Offset(center.dx + size.shortestSide / 2 - 3, center.dy - 8),
    );

    final textPainter9 = TextPainter(
      text: TextSpan(
        text: '9',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter9.layout(
      minWidth: 16,
      maxWidth: size.width,
    );
    textPainter9.paint(
      canvas,
      Offset(center.dx - size.shortestSide / 2 - 13, center.dy - 8),
    );

    final textPainter12 = TextPainter(
      text: TextSpan(
        text: '12',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter12.layout(
      minWidth: 16,
      maxWidth: size.width,
    );
    textPainter12.paint(
      canvas,
      Offset(center.dx - 8, center.dy - size.shortestSide / 2 - 12),
    );

    final textPainter6 = TextPainter(
      text: TextSpan(
        text: '6',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter6.layout(
      minWidth: 16,
      maxWidth: size.width,
    );
    textPainter6.paint(
      canvas,
      Offset(center.dx - 8, center.dy + size.shortestSide / 2 - 3),
    );
  }

  @override
  bool shouldRepaint(NumbersPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.customTheme != customTheme;
  }
}
