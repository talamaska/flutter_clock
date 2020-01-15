import 'package:analog_clock/hand_painter.dart';
import 'package:flutter/widgets.dart';

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
    @required this.numbersController,
    @required this.progressController,
  });

  final Color bodyColor;
  final Color fillColor;
  final double size;
  final double angleRadians;
  final double handHeadRadius;
  final double thickness;
  final String text;
  final int now;
  final AnimationController numbersController;
  final AnimationController progressController;

  @override
  _HandBodyState createState() => _HandBodyState();
}

class _HandBodyState extends State<HandBody> {
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
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
    );
  }
}
