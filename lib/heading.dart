import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/weather.dart';

abstract class ListItem {}

class DayHeading extends ListItem {
  final DateTime dateTime;

  DayHeading(this.dateTime);
}

class HeadingListItem extends StatelessWidget implements ListItem {
  static var _dateFormaWeekDay = DateFormat('EEEE');
  final DayHeading dayHeading;

  HeadingListItem(this.dayHeading);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(children: [
        Text(
          "${HeadingListItem._dateFormaWeekDay.format(
              dayHeading.dateTime)} ${dayHeading.dateTime.day}.${dayHeading
              .dateTime.month}.${dayHeading.dateTime.year}",
          style: Theme
              .of(context)
              .textTheme
              .headline6,
        ),
        Divider()
      ],),
    );
  }
}