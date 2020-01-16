import 'package:analog_clock/hand_circle_painter.dart';
import 'package:flutter/widgets.dart';

class HandBodyCircle extends StatefulWidget {
  final Widget child;
  HandBodyCircle({
    this.child,
    @required this.borderColor,
    @required this.fillColor,
    @required this.size,
    @required this.offCenter,
    @required this.angleRadians,
    @required this.handHeadRadius,
    @required this.thickness,
    @required this.text,
    @required this.now,
    @required this.numbersController,
    @required this.progressController,
  });

  final Color borderColor;
  final Color fillColor;
  final double size;
  final double offCenter;
  final double angleRadians;
  final double handHeadRadius;
  final double thickness;
  final String text;
  final int now;
  final AnimationController numbersController;
  final AnimationController progressController;

  @override
  _HandBodyCircleState createState() => _HandBodyCircleState();
}

class _HandBodyCircleState extends State<HandBodyCircle> {
  Animation<double> _handAnimation;
  @override
  void initState() {
    super.initState();
    _handAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
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
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
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
    );
  }
}
