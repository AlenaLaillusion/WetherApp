

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'heading.dart';

class Weather extends ListItem {
  static const String weatherUrl = "http://openweathermap.org/img/w/";

  DateTime dateTime;
  num degree;
  int clouds;
  String iconUrl;

  String getIconUrl(){
    return weatherUrl + iconUrl + ".png";
  }
  Weather(this.dateTime, this.degree, this.clouds, this.iconUrl);
}

class WeatherListItem extends StatelessWidget {
  static var _dateFormat = DateFormat('yyyy-MM-dd - hh:mm');

  final Weather weather;

  WeatherListItem(this.weather);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        Expanded(
          flex: 3,
        child: Text(_dateFormat.format(weather.dateTime)),),
        Expanded(
          flex: 1,
          child: Text(weather.degree.toString() + " C"),
        ),
        Expanded(
          flex: 1,
          child: Image.network(weather.getIconUrl()),
        )
      ],),
    );
  }
}

