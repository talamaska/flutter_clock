import 'package:analog_clock/analog_clock_icons.dart';
import 'package:flutter/material.dart';

class ClockTexts extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                _weaterIcons[_condition],
                color: customTheme.primaryColor,
                size: 60,
              ),
              RichText(
                text: TextSpan(
                  text: _temperature,
                  style: customTheme.primaryTextTheme.body2.copyWith(
                    color: customTheme.primaryColor,
                    fontSize: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            width: 100,
            padding: EdgeInsets.all(6),
            child: Text(
              _temperatureHigh,
              textAlign: TextAlign.right,
              style: customTheme.primaryTextTheme.body1.copyWith(
                color: Colors.red,
                fontSize: 24,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.all(6),
            width: 100,
            child: Text(
              _temperatureLow,
              textAlign: TextAlign.right,
              style: customTheme.primaryTextTheme.body1.copyWith(
                color: Colors.blue,
                fontSize: 24,
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Text(
              _location,
              textAlign: TextAlign.right,
              style: customTheme.primaryTextTheme.body1.copyWith(
                color: customTheme.primaryColor,
                fontSize: 14,
              ),
            ))
      ],
    );
  }
}
