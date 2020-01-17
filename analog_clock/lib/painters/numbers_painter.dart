import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as vm;

class NumbersPainter extends CustomPainter {
  final Color color;
  final double scale;
  final double opacity;
  final String text;
  final double thickness;
  final double handSize;
  final double handHeadRadius;
  final int now;

  NumbersPainter({
    this.scale,
    this.opacity,
    this.text,
    this.color,
    this.now,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withOpacity(opacity),
          fontSize: handHeadRadius * 2 * 0.6 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    canvas.save();

    // debugPrint('$test');
    // canvas.translate(size.longestSide / 2, thickness + handHeadRadius * 2);
    // canvas.translate(
    //   size.longestSide / 2,
    //   thickness + handHeadRadius + (1 - handSize) * size.shortestSide,
    // );
    canvas.rotate(-now * vm.radians(360 / 60));

    // hand head
    textPainter.layout(
      minWidth: size.width,
      maxWidth: size.width,
    );

    final offset = Offset(
      -handHeadRadius,
      -handHeadRadius + handHeadRadius * 0.3,
    );
    textPainter.paint(canvas, offset);
    canvas.rotate(vm.radians(270));

    // canvas.translate(size.longestSide / 2, thickness + handHeadRadius * 2);
    // canvas.translate(
    //   -size.longestSide / 2,
    //   -thickness + handHeadRadius + (1 - handSize) * size.shortestSide,
    // );

    // canvas.restore();
    canvas.restore();
    // canvas.scale(scale);
    // debugPrint('scale $scale');
  }

  @override
  bool shouldRepaint(NumbersPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.handSize != handSize ||
        oldDelegate.scale != scale ||
        oldDelegate.opacity != opacity ||
        oldDelegate.text != text ||
        oldDelegate.handHeadRadius != handHeadRadius;
  }
}
