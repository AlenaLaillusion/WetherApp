import 'package:flutter/material.dart';
import 'package:weather_app/heading.dart';
import 'package:weather_app/weather.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return WeatherForcecastPage("Moskow");
  }
}


class WeatherForcecastPage extends StatefulWidget {
  WeatherForcecastPage(this.cityName);

  final String cityName;

  @override
  State<StatefulWidget> createState() {
  return _WeatherForcecastPageState();
  }
}

class _WeatherForcecastPageState extends State<WeatherForcecastPage> {
  List<ListItem> weatherForcast = List<ListItem>();
  @override
  void initState() {
    var itCurrentDay = DateTime.now();
    weatherForcast.add(DayHeading(itCurrentDay)); //first heading
    List<ListItem> weatherData = [
    Weather(itCurrentDay, 20, 90, "04d"),
      Weather(itCurrentDay.add(Duration(hours: 3)), 23, 50, "03d"),
      Weather(itCurrentDay.add(Duration(hours: 5)), 23, 55, "03d"),
    Weather(itCurrentDay.add(Duration(hours: 6)), 25, 50, "02d"),
    Weather(itCurrentDay.add(Duration(hours: 9)), 20, 60, "01d"),
    Weather(itCurrentDay.add(Duration(hours: 17)), 24, 60, "02d"),
    Weather(itCurrentDay.add(Duration(hours: 32)), 28, 50, "01d")
    ];
    var itNextDay = DateTime.now().add(Duration(days: 1));
    itNextDay = DateTime(
      itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
    var iterator = weatherData.iterator;
    while (iterator.moveNext()) {
      var weatherDateTime = iterator.current as Weather;
      if(weatherDateTime.dateTime.isAfter(itNextDay)) {
        itCurrentDay = itNextDay;
        itNextDay = itCurrentDay.add(Duration(days: 1));
        itNextDay = DateTime(
          itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
        weatherForcast.add(DayHeading(itCurrentDay)); //next heading
      } else {
        weatherForcast.add(iterator.current);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView Simple',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather forecast'),
        ),
        body: ListView.builder(
          itemCount: weatherForcast.length,
            itemBuilder: (BuildContext context, int index) {
            final item = weatherForcast[index];
            if (item is Weather) {
              return WeatherListItem(item);
            } else if(item is DayHeading) {
              return HeadingListItem(item);
            } else
            throw Exception('wrong type');
            }
        )));
  }}



