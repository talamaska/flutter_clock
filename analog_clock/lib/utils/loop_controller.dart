import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flare_dart/math/mat2d.dart';

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
