
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/model/forecast_response.dart';


abstract class ListItemWidget {}

class WeatherListItem extends StatelessWidget implements ListItemWidget {
  static var _dateFormat = DateFormat('yyyy-MM-dd – HH:mm');

  final WeatherListBean weather;

  WeatherListItem(this.weather);


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.only(right: 16.0),
              child:
                Text(_dateFormat.format(weather.getDateTime()),
                style: Theme.of(context).textTheme.subhead,)),
          Image.network(weather.getIconUrl()),
          Text((weather.main.temp.toInt()).toString() + " \u00B0C",
          style: Theme.of(context).textTheme.subhead),
        ]));
  }
}

class HeadingListItem extends StatelessWidget implements ListItemWidget {
  static var _dateFormatWeekDay = DateFormat('EEEE');
  final DayHeading dayHeading;

  HeadingListItem(this.dayHeading);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(children: [
        Text(
          "${_dateFormatWeekDay.format(dayHeading.dateTime)} ${dayHeading.dateTime.day}.${dayHeading.dateTime.month}",
          style: Theme.of(context).textTheme.headline,
        ),
        Divider()
      ]),
    );
  }
}


class Weather extends ListItem {
  static const String weatherURL = "http://openweathermap.org/img/w/";

  DateTime dateTime;
  num degree;
  int clouds;
  String iconURL;

  String getIconUrl() {
    return weatherURL + iconURL + ".png";
  }

  Weather(this.dateTime, this.degree, this.clouds, this.iconURL);
}

class DayHeading extends ListItem {
  final DateTime dateTime;

  DayHeading(this.dateTime);
}

