import 'package:analog_clock/utils/analog_clock_icons.dart';
import 'package:analog_clock/utils/loop_controller.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flutter/semantics.dart';

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

  final _weaterIcons = {
    "cloudy": AnalogClock.clouds_inv,
    "foggy": AnalogClock.fog,
    "rainy": AnalogClock.rain_inv,
    "snowy": AnalogClock.snow_heavy_inv,
    "sunny": AnalogClock.sun_inv,
    "thunderstorm": AnalogClock.cloud_flash_inv,
    "windy": AnalogClock.wind,
  };

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
                height: 60,
                width: 80,
                child: Semantics.fromProperties(
                  properties: SemanticsProperties(
                    label: 'Current weather condition is ${widget._condition}',
                  ),
                  child: (kIsWeb)
                      ? Center(
                          child: Icon(
                            widget._weaterIcons[widget._condition],
                            color: widget.customTheme.primaryColor,
                            size: 40,
                          ),
                        )
                      : FlareActor(
                          "assets/animations/${widget._condition}.flr",
                          animation: 'loop',
                          color: widget.customTheme.accentColor,
                          fit: BoxFit.cover,
                          controller: _loopController,
                        ),
                ),
              ),
              RichText(
                text: TextSpan(
                  semanticsLabel:
                      'The current temperature outside is ${widget._temperature}',
                  text: widget._temperature,
                  style: widget.customTheme.textTheme.body1.copyWith(
                    color: widget.customTheme.accentColor,
                    fontSize: 20,
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
                  style: widget.customTheme.textTheme.body1.copyWith(
                    color: widget.customTheme.accentColor,
                    fontSize: 20,
                  ),
                  semanticsLabel:
                      'The highest temperature for the day will be ${widget._temperatureHigh}',
                ),
              ),
              Container(
                width: 100,
                child: Text(
                  widget._temperatureLow,
                  textAlign: TextAlign.right,
                  style: widget.customTheme.textTheme.body1.copyWith(
                    color: widget.customTheme.buttonColor,
                    fontSize: 20,
                  ),
                  semanticsLabel:
                      'The lowest temperature for the day will be ${widget._temperatureLow}',
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          width: 120,
          child: Text(
            widget._location,
            maxLines: 3,
            textAlign: TextAlign.left,
            style: widget.customTheme.textTheme.body1.copyWith(
              color: widget.customTheme.buttonColor,
              fontSize: 14,
            ),
            semanticsLabel: 'Your current location is ${widget._location}',
          ),
        )
      ],
    );
  }
}
