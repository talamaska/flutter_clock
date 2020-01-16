import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as vm;

class BackgroundAnimated extends StatefulWidget {
  final AnimationController controller;

  BackgroundAnimated({
    this.controller,
  });

  @override
  _BackgroundAnimatedState createState() => _BackgroundAnimatedState();
}

class _BackgroundAnimatedState extends State<BackgroundAnimated> {
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
        painter: BackgroundPaint(rotation: _handAnimation.value),
      ),
    );
  }
}

class BackgroundPaint extends CustomPainter {
  final double rotation;
  BackgroundPaint({this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    // debugPrint('$rotation');
    final center = (Offset.zero & size).center;
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.2)
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt;

    canvas.save();

    canvas.drawCircle(
      Offset(-0.25 * size.shortestSide, 0.25 * size.shortestSide),
      // center,
      size.shortestSide / 2,
      paint,
    );

    canvas.translate(-0.28 * size.shortestSide, 0.28 * size.shortestSide);
    canvas.rotate(vm.radians(rotation));

    canvas.restore();
  }

  @override
  bool shouldRepaint(BackgroundPaint oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
