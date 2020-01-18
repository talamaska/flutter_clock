import 'package:analog_clock/analog_clock_icons.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_dart/math/mat2d.dart';

class ClockTexts extends StatefulWidget {
  ClockTexts({
    Key key,
    @required String temperatureHigh,
    @required String temperatureLow,
    @required String temperature,
    @required String location,
    @required String condition,
    @required this.customTheme,
  })  : _temperatureHigh = temperatureHigh,
        _temperatureLow = temperatureLow,
        _temperature = temperature,
        _condition = condition,
        _location = location,
        super(key: key);

  final String _temperatureHigh;
  final String _temperatureLow;
  final String _temperature;
  final String _condition;
  final String _location;
  final ThemeData customTheme;

  @override
  _ClockTextsState createState() => _ClockTextsState();
}

class _ClockTextsState extends State<ClockTexts> {
  AnimationLoopController _loopController = AnimationLoopController('loop');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                child: FlareActor(
                  "assets/animations/${widget._condition}.flr",
                  animation: 'loop',
                  color: widget.customTheme.primaryColor,
                  fit: BoxFit.cover,
                  controller: _loopController,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: widget._temperature,
                  style: widget.customTheme.primaryTextTheme.body2.copyWith(
                    color: widget.customTheme.primaryColor,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Column(
            children: <Widget>[
              Container(
                width: 100,
                child: Text(
                  widget._temperatureHigh,
                  textAlign: TextAlign.right,
                  style: widget.customTheme.primaryTextTheme.body1.copyWith(
                    color: Colors.red,
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                width: 100,
                child: Text(
                  widget._temperatureLow,
                  textAlign: TextAlign.right,
                  style: widget.customTheme.primaryTextTheme.body1.copyWith(
                    color: Colors.blue,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Text(
              widget._location,
              textAlign: TextAlign.right,
              style: widget.customTheme.primaryTextTheme.body1.copyWith(
                color: widget.customTheme.primaryColor,
                fontSize: 14,
              ),
            ))
      ],
    );
  }
}

class AnimationLoopController implements FlareController {
  final String _loopAnimationName;
  final double _mix;

  AnimationLoopController(this._loopAnimationName, [this._mix = 1.0]);

  bool _looping = true;
  double _duration = 0.0;

  ActorAnimation _loopAnimation;

  @override
  void initialize(FlutterActorArtboard artboard) {
    _loopAnimation = artboard.getAnimation(_loopAnimationName);
    debugPrint('${_loopAnimation.duration}');
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _duration += elapsed;

    if (_looping) {
      _duration %= _loopAnimation.duration;

      _loopAnimation.apply(_duration, artboard, _mix);
    }
    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  ValueNotifier<bool> isActive;
}
