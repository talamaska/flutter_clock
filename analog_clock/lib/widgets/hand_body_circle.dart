import 'package:analog_clock/painters/hand_circle_painter.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';

class HandBodyCircle extends StatefulWidget {
  final Widget child;
  HandBodyCircle({
    this.child,
    this.isHourHand = false,
    @required this.borderColor,
    @required this.fillColor,
    @required this.size,
    @required this.offCenter,
    @required this.angleRadians,
    @required this.handHeadRadius,
    @required this.thickness,
    @required this.text,
    @required this.now,
    @required this.progressController,
    @required this.rotationController,
  });

  final bool isHourHand;
  final Color fillColor;
  final Color borderColor;
  final double size;
  final double offCenter;
  final double angleRadians;
  final double handHeadRadius;
  final double thickness;
  final String text;
  final int now;

  final AnimationController rotationController;
  final AnimationController progressController;

  @override
  _HandBodyCircleState createState() => _HandBodyCircleState();
}

class _HandBodyCircleState extends State<HandBodyCircle> {
  Animation<double> _handAnimation;
  Animation<double> _rotationAnimation;
  @override
  void initState() {
    super.initState();
    final double rotationDegrees = widget.isHourHand ? 720 : 360;
    _handAnimation = Tween<double>(begin: 0.0, end: 360).animate(
      CurvedAnimation(
        parent: widget.progressController,
        curve: Curves.linear,
      ),
    );

    _handAnimation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _rotationAnimation =
        Tween<double>(begin: 0.0, end: rotationDegrees).animate(
      CurvedAnimation(
        parent: widget.rotationController,
        curve: Curves.linear,
      ),
    );

    _rotationAnimation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: radians(_rotationAnimation.value),
      child: CustomPaint(
        painter: HandCirclePainter(
          borderColor: widget.borderColor,
          fillColor: widget.fillColor,
          thickness: widget.thickness,
          handSize: widget.size,
          offCenter: widget.offCenter,
          handHeadRadius: widget.handHeadRadius,
          value: _handAnimation.value,
          now: widget.now,
          text: widget.text,
        ),
        child: widget.child,
      ),
    );
  }
}
