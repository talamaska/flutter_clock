import 'package:analog_clock/helpers.dart';
import 'package:analog_clock/painters/hand_painter.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';

class HandBody extends StatefulWidget {
  final Widget child;
  HandBody({
    this.child,
    @required this.bodyColor,
    @required this.fillColor,
    @required this.size,
    @required this.angleRadians,
    @required this.handHeadRadius,
    @required this.thickness,
    @required this.text,
    @required this.now,
    @required this.progressController,
    @required this.fullRotationController,
    this.isHourHand = false,
  });

  final bool isHourHand;
  final Color bodyColor;
  final Color fillColor;
  final double size;
  final double angleRadians;
  final double handHeadRadius;
  final double thickness;
  final String text;
  final int now;
  final AnimationController progressController;
  final AnimationController fullRotationController;

  @override
  _HandBodyState createState() => _HandBodyState();
}

class _HandBodyState extends State<HandBody> {
  Animation<double> _handAnimation;
  Animation<double> _rotationAnimation;
  double _rotationDegrees;
  @override
  void initState() {
    super.initState();
    _rotationDegrees = widget.isHourHand ? 720 : 360;
    _handAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: widget.progressController,
        curve: Curves.linear,
      ),
    );
    _rotationAnimation =
        Tween<double>(begin: 0.0, end: _rotationDegrees).animate(
      CurvedAnimation(
        parent: widget.fullRotationController,
        curve: Curves.linear,
      ),
    );

    _handAnimation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _rotationAnimation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isHourHand) {
      // debugPrint();
      // debugPrint('${_rotationAnimation.value}');
    }
    return Transform.rotate(
      angle: widget.angleRadians,
      child: CustomPaint(
        painter: HandPainter(
          color: widget.bodyColor,
          thickness: widget.thickness,
          handSize: widget.size,
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
