import 'package:analog_clock/progress_painer.dart';
import 'package:flutter/widgets.dart';

class HandProgress extends StatefulWidget {
  final Color color;
  final Color circleColor;
  final Color textColor;
  final double thickness;
  final double handSize;
  final double handHeadRadius;
  // final double value;
  final String text;
  final int now;
  final AnimationController progressController;
  final AnimationController numbersController;

  // static const _secondTextStyle = TextStyle(
  //   color: Colors.red,
  //   fontSize: 10,
  //   fontWeight: FontWeight.bold,
  // );

  HandProgress({
    @required this.color,
    @required this.circleColor,
    @required this.textColor,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
    // @required this.value,
    @required this.now,
    @required this.text,
    @required this.numbersController,
    @required this.progressController,
  })  : assert(color != null),
        assert(numbersController != null),
        assert(progressController != null),
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
  Animation<double> _scaleAnimation;
  Animation<double> _opacityAnimation;
  Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: widget.progressController,
        curve: Curves.linear,
      ),
    );

    // _scaleAnimation = Tween<double>(begin: 1.0, end: 5.0).animate(
    //   CurvedAnimation(
    //     parent: widget.numbersController,
    //     curve: Curves.easeInOut,
    //   ),
    // );
    // _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
    //   CurvedAnimation(
    //     parent: widget.numbersController,
    //     curve: Curves.easeInOut,
    //   ),
    // );

    _progressAnimation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    // _scaleAnimation.addListener(() {
    //   setState(() {});
    // });
    // _opacityAnimation.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HandProgressPainter(
        color: widget.color,
        circleColor: widget.circleColor,
        textColor: widget.textColor,
        thickness: widget.thickness,
        handSize: widget.handSize,
        handHeadRadius: widget.handHeadRadius,
        value: _progressAnimation.value,
        now: widget.now,
        text: widget.text,
        // scale: _scaleAnimation.value,
        // opacity: _opacityAnimation.value,
      ),
    );
  }
}
