//@Author: Pasupathi, gmail_id:pasupathiakash@gmail.com
// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the FONT_LICENSE file.
// found in the ICON_LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

enum _ElementColor {
  timeWidgetBackgroundColor,
  dateWidgetBackgroundColor,
  dayWidgetBackgroundColor,
  weatherWidgetBackgroundColor,
  timeTextColor,
  dateTextColor,
  dayTextColor,
  weatherTextColor,
  iconTintColor,
}

final _lightTheme = {
  _ElementColor.timeWidgetBackgroundColor: Color(0xFFcddc39),
  _ElementColor.dateWidgetBackgroundColor: Color(0xFF9ccc65),
  _ElementColor.dayWidgetBackgroundColor: Color(0xFFFAFAFA),
  _ElementColor.weatherWidgetBackgroundColor: Color(0xFFFAFAFA),
  _ElementColor.timeTextColor: Color(0xFF242424),
  _ElementColor.dateTextColor: Color(0xFF242424),
  _ElementColor.dayTextColor: Color(0xFF263238),
  _ElementColor.weatherTextColor: Color(0xFF263238),
  _ElementColor.iconTintColor: Color(0xFF1b5e20),
};

final _darkTheme = {
  _ElementColor.timeWidgetBackgroundColor: Color(0xFF121212),
  _ElementColor.dateWidgetBackgroundColor: Color(0xFF242424),
  _ElementColor.dayWidgetBackgroundColor: Color(0xFF263238),
  _ElementColor.weatherWidgetBackgroundColor: Color(0xFF263238),
  _ElementColor.timeTextColor: Color(0xFFcddc39),
  _ElementColor.dateTextColor: Color(0xFF9ccc65),
  _ElementColor.dayTextColor: Color(0xFFFAFAFA),
  _ElementColor.weatherTextColor: Color(0xFFFAFAFA),
  _ElementColor.iconTintColor: Color(0xFF03DAc6),
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();

  var _temperature = '';
  var _condition = '';
  var _location = '';
  var _amPmMarker = '';
  var _date = '';
  var _hour = '';
  var _minute = '';
  var _widgetPadding = 10.0;

  static const _sunday = 'Sun';
  static const _monday = 'Mon';
  static const _tuesday = 'Tue';
  static const _wednesday = 'Wed';
  static const _thursday = 'Thu';
  static const _friday = 'Fri';
  static const _saturday = 'Sat';

  static const _cloudy = 'cloudy';
  static const _foggy = 'foggy';
  static const _rainy = 'rainy';
  static const _snowy = 'snowy';
  static const _sunny = 'sunny';
  static const _thunderstorm = 'thunderstorm';
  static const _windy = 'windy';

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _condition = widget.model.weatherString;
      _location = widget.model.location;
      _amPmMarker = DateFormat('a').format(_dateTime);
      _date = DateFormat('dd MMM yyyy').format(_dateTime);
      _hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
          .format(_dateTime);
      _minute = DateFormat('mm').format(_dateTime);
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    return AspectRatio(
        aspectRatio: 5 / 3,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  color: colors[_ElementColor.timeWidgetBackgroundColor],
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: timeWidget(colors),
                      ),
                      Expanded(
                        flex: 1,
                        child: dayColumnWidget(colors),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: weatherWidget(colors),
                      ),
                      Expanded(
                        flex: 4,
                        child: dateWidget(colors),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget timeWidget(Map<_ElementColor, Color> colors) {
    return Container(
      padding: EdgeInsets.all(
        _widgetPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: widget.model.is24HourFormat ? 10 : 8,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                '$_hour:$_minute',
                style: textFontStyle(
                  fontWeight: FontWeight.w600,
                  fontColor: colors[_ElementColor.timeTextColor],
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.model.is24HourFormat == false,
            child: Expanded(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  _amPmMarker.toString(),
                  style: textFontStyle(
                    fontWeight: FontWeight.w500,
                    fontColor: colors[_ElementColor.timeTextColor],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dayColumnWidget(Map<_ElementColor, Color> colors) {
    return Container(
      color: colors[_ElementColor.dayWidgetBackgroundColor],
      padding: EdgeInsets.all(
        _widgetPadding,
      ),
      child: Column(
        children: <Widget>[
          dayWidget(
            _sunday,
            _dateTime.weekday == DateTime.sunday ? 1 : 0.3,
            iconTintColor: colors[_ElementColor.iconTintColor],
            dayTextColor: colors[_ElementColor.dayTextColor],
          ),
          dayWidget(
            _monday,
            _dateTime.weekday == DateTime.monday ? 1 : 0.3,
            iconTintColor: colors[_ElementColor.iconTintColor],
            dayTextColor: colors[_ElementColor.dayTextColor],
          ),
          dayWidget(
            _tuesday,
            _dateTime.weekday == DateTime.tuesday ? 1 : 0.3,
            iconTintColor: colors[_ElementColor.iconTintColor],
            dayTextColor: colors[_ElementColor.dayTextColor],
          ),
          dayWidget(
            _wednesday,
            _dateTime.weekday == DateTime.wednesday ? 1 : 0.3,
            iconTintColor: colors[_ElementColor.iconTintColor],
            dayTextColor: colors[_ElementColor.dayTextColor],
          ),
          dayWidget(
            _thursday,
            _dateTime.weekday == DateTime.thursday ? 1 : 0.3,
            iconTintColor: colors[_ElementColor.iconTintColor],
            dayTextColor: colors[_ElementColor.dayTextColor],
          ),
          dayWidget(
            _friday,
            _dateTime.weekday == DateTime.friday ? 1 : 0.3,
            iconTintColor: colors[_ElementColor.iconTintColor],
            dayTextColor: colors[_ElementColor.dayTextColor],
          ),
          dayWidget(
            _saturday,
            _dateTime.weekday == DateTime.saturday ? 1 : 0.3,
            iconTintColor: colors[_ElementColor.iconTintColor],
            dayTextColor: colors[_ElementColor.dayTextColor],
          ),
        ],
      ),
    );
  }

  Widget dayWidget(
    String day,
    double opVal, {
    iconTintColor,
    dayTextColor,
  }) {
    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: FittedBox(
                fit: BoxFit.contain,
                child: Opacity(
                    opacity: opVal,
                    child: Icon(
                      Icons.check_box,
                      color: iconTintColor,
                    ))),
          ),
          Expanded(
            flex: 15,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 10,
                ),
                child: Opacity(
                  opacity: opVal == 1 ? opVal : 0.5,
                  child: Text(
                    day,
                    style: textFontStyle(
                        fontColor: dayTextColor,
                        fontWeight:
                            opVal == 1 ? FontWeight.w600 : FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget weatherWidget(colors) {
    return Container(
      color: colors[_ElementColor.weatherWidgetBackgroundColor],
      padding: EdgeInsets.all(
        _widgetPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Row(
                children: <Widget>[
                  Icon(
                    weatherIcon(weatherName: _condition),
                    color: colors[_ElementColor.iconTintColor],
                  ),
                  Text(
                    _temperature,
                    style: textFontStyle(
                      fontWeight: FontWeight.w600,
                      fontColor: colors[_ElementColor.weatherTextColor],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                _condition,
                style: textFontStyle(
                  fontColor: colors[_ElementColor.weatherTextColor],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                _location.length > 25
                    ? "${_location.substring(0, 23)}..."
                    : _location,
                style: textFontStyle(
                  fontWeight: FontWeight.w300,
                  fontColor: colors[_ElementColor.weatherTextColor],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dateWidget(colors) {
    return Container(
      color: colors[_ElementColor.dateWidgetBackgroundColor],
      padding: EdgeInsets.all(
        _widgetPadding,
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          '$_date',
          style: textFontStyle(
            fontWeight: FontWeight.w500,
            fontColor: colors[_ElementColor.dateTextColor],
          ),
        ),
      ),
    );
  }

  weatherIcon({weatherName = ''}) {
    const _kFontFam = 'WeatherIcon';
    switch (weatherName) {
      case _cloudy:
        {
          return IconData(0xe811, fontFamily: _kFontFam);
        }
      case _foggy:
        {
          return IconData(0xe80c, fontFamily: _kFontFam);
        }
      case _rainy:
        {
          return IconData(0xe812, fontFamily: _kFontFam);
        }
      case _snowy:
        {
          return IconData(0xe80f, fontFamily: _kFontFam);
        }
      case _sunny:
        {
          return IconData(0xe810, fontFamily: _kFontFam);
        }
      case _thunderstorm:
        {
          return IconData(0xe80e, fontFamily: _kFontFam);
        }
      case _windy:
        {
          return IconData(0xe80d, fontFamily: _kFontFam);
        }
        break;
    }
  }

  textFontStyle({
    fontWeight = FontWeight.w400,
    fontColor = Colors.black38,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: fontColor,
      fontWeight: fontWeight,
    );
  }
}
