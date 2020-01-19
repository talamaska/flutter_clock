import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as vm;

class BackgroundCircle extends StatefulWidget {
  final AnimationController controller;
  final Color color;
  final double radius;
  final Offset circleOffset;
  final Offset rotationOffset;

  BackgroundCircle({
    this.controller,
    this.color,
    this.radius,
    this.circleOffset,
    this.rotationOffset,
  })  : assert(color != null),
        assert(radius != null),
        assert(controller != null),
        assert(circleOffset != null),
        assert(rotationOffset != null);

  @override
  _BackgroundCircleState createState() => _BackgroundCircleState();
}

class _BackgroundCircleState extends State<BackgroundCircle> {
  Animation<double> _handAnimation;
  @override
  void initState() {
    super.initState();
    _handAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Curves.linear,
      ),
    );

    _handAnimation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: BackgroundPaint(
          rotation: _handAnimation.value,
          color: widget.color,
          radius: widget.radius,
          circleOffset: widget.circleOffset,
          rotationOffset: widget.rotationOffset,
        ),
      ),
    );
  }
}

class BackgroundPaint extends CustomPainter {
  final Color color;
  final double rotation;
  final double radius;
  final Offset circleOffset;
  final Offset rotationOffset;
  BackgroundPaint({
    this.color,
    this.rotation,
    this.radius,
    this.circleOffset,
    this.rotationOffset,
  })  : assert(color != null),
        assert(rotation != null),
        assert(radius != null),
        assert(circleOffset != null),
        assert(rotationOffset != null);

  @override
  void paint(Canvas canvas, Size size) {
    // debugPrint('$rotation');
    final center = (Offset.zero & size).center;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt;

    canvas.save();
    // canvas.translate(rotationOffset.dx * size.longestSide,
    //     rotationOffset.dy * size.shortestSide);
    // canvas.rotate(vm.radians(rotation));
    // final rect = Rect.fromCenter(
    //     center: Offset(-0.1 * size.shortestSide, 0.1 * size.shortestSide),
    //     width: size.shortestSide / 2,
    //     height: size.shortestSide / 2);

    // canvas.drawOval(rect, paint);
    canvas.drawCircle(
      Offset(
        circleOffset.dx * size.longestSide,
        circleOffset.dy * size.shortestSide,
      ),
      // Offset(size.shortestSide / 2, size.shortestSide / 2),
      // center,
      size.shortestSide * radius,
      paint,
    );

    // canvas.translate(0.5 * size.shortestSide, -0.5 * size.shortestSide);

    canvas.restore();
  }

  @override
  bool shouldRepaint(BackgroundPaint oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
