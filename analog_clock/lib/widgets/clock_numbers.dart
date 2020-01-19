import 'package:flutter/material.dart';

class ClockNumbers extends StatelessWidget {
  const ClockNumbers({
    Key key,
    @required this.customTheme,
  }) : super(key: key);

  final ThemeData customTheme;

  @override
  Widget build(BuildContext context) {
    return Numbers(
      text: '3',
      customTheme: customTheme,
    );
  }
}

class Numbers extends StatelessWidget {
  const Numbers({
    Key key,
    @required this.customTheme,
    @required this.text,
  }) : super(key: key);

  final ThemeData customTheme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomPaint(
            key: key,
            painter: NumbersPainter(
              color: customTheme.accentColor,
              text: text,
              customTheme: customTheme,
            ),
          ),
        ),
      ),
    );
  }
}

class NumbersPainter extends CustomPainter {
  final Color color;
  final String text;
  final ThemeData customTheme;

  NumbersPainter({
    Key key,
    @required this.customTheme,
    @required this.color,
    @required this.text,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final TextStyle textStyle = customTheme.textTheme.body2.copyWith(
      color: customTheme.accentColor,
      fontSize: 16,
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
      Offset(center.dx - size.shortestSide / 2 - 13, center.dy - 4),
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
      Offset(center.dx - 8, center.dy + size.shortestSide / 2 - 2),
    );

    // textPainter.paint(canvas, Offset(0, size.shortestSide / 2));
    // textPainter.paint(canvas, Offset(size.shortestSide, size.shortestSide));
    // textPainter.paint(canvas, Offset(size.shortestSide / 2, size.shortestSide));
  }

  @override
  bool shouldRepaint(NumbersPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.color != color ||
        oldDelegate.customTheme != customTheme;
  }
}
