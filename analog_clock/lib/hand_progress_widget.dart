import 'package:analog_clock/progress_painer.dart';
import 'package:flutter/widgets.dart';

class HandProgressWidget extends StatefulWidget {
  final Color color;
  final Color circleColor;
  final double thickness;
  final double handSize;
  final double handHeadRadius;
  final double value;
  final String text;
  final int now;
  final AnimationController progressController;
  final AnimationController numbersController;

  // static const _secondTextStyle = TextStyle(
  //   color: Colors.red,
  //   fontSize: 10,
  //   fontWeight: FontWeight.bold,
  // );

  HandProgressWidget({
    @required this.color,
    @required this.circleColor,
    @required this.handSize,
    @required this.thickness,
    @required this.handHeadRadius,
    @required this.value,
    @required this.now,
    @required this.text,
    @required this.numbersController,
    @required this.progressController,
  })  : assert(color != null),
        assert(numbersController != null),
        assert(progressController != null),
        assert(circleColor != null),
        assert(thickness != null),
        assert(handHeadRadius != null),
        assert(handSize != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);
  @override
  _HandProgressWidgetState createState() => _HandProgressWidgetState();
}

class _HandProgressWidgetState extends State<HandProgressWidget>
    with TickerProviderStateMixin {
  Animation<double> _scaleAnimation;
  Animation<double> _opacityAnimation;
  // Animation<double> _secondsAnimation;

  @override
  void initState() {
    super.initState();
    // _secondsAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
    //   CurvedAnimation(
    //     parent: widget.progressController,
    //     curve: Curves.linear,
    //   ),
    // );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 5.0).animate(
      CurvedAnimation(
        parent: widget.numbersController,
        curve: Curves.easeInOut,
      ),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: widget.numbersController,
        curve: Curves.easeInOut,
      ),
    );
    // _secondsAnimation.addListener(() {
    //   setState(() {});
    // });
    _scaleAnimation.addListener(() {
      setState(() {});
    });
    _opacityAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HandProgress(
        color: widget.color,
        circleColor: widget.circleColor,
        thickness: widget.thickness,
        handSize: widget.handSize,
        handHeadRadius: widget.handHeadRadius,
        value: widget.value,
        now: widget.now,
        text: widget.text,
        scale: _scaleAnimation.value,
        opacity: _opacityAnimation.value,
      ),
    );
  }
}
