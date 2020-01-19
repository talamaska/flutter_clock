import 'package:analog_clock/painters/progress_painer.dart';
import 'package:flutter/widgets.dart';

class HandProgress extends StatefulWidget {
  final bool isHourHand;
  final Color color;
  final Color circleColor;
  final Color textColor;
  final double thickness;
  final double handSize;
  final double handHeadRadius;

  final AnimationController progressController;
  final AnimationController rotationController;

  HandProgress({
    @required this.color,
    @required this.circleColor,
    @required this.textColor,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
    @required this.progressController,
    @required this.rotationController,
    this.isHourHand = false,
  })  : assert(color != null),
        assert(progressController != null),
        assert(rotationController != null),
        assert(circleColor != null),
        assert(textColor != null),
        assert(thickness != null),
        assert(handHeadRadius != null),
        assert(handSize != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);
  @override
  _HandProgressState createState() => _HandProgressState();
}

class _HandProgressState extends State<HandProgress> {
  Animation<double> _progressAnimation;
  Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    final double rotationDegrees = widget.isHourHand ? 720 : 360;
    _progressAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: widget.progressController,
        curve: Curves.linear,
      ),
    );

    _progressAnimation.addListener(() {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.isHourHand) {
    //   debugPrint('test ${_rotationAnimation.value}');
    // }
    return CustomPaint(
      painter: HandProgressPainter(
        color: widget.color,
        circleColor: widget.circleColor,
        textColor: widget.textColor,
        thickness: widget.thickness,
        handSize: widget.handSize,
        handHeadRadius: widget.handHeadRadius,
        value: _progressAnimation.value,
        isHourHand: widget.isHourHand,
        rotation: _rotationAnimation.value,
      ),
    );
  }
}
