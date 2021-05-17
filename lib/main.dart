import 'package:flutter/material.dart';
import 'package:weather_app/weather.dart';

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
  List<Weather> weatherForcast = [
    Weather(DateTime.now(), 20, 90, "04d"),
    Weather(DateTime.now().add(Duration(hours: 3)), 23, 50, "03d"),
    Weather(DateTime.now().add(Duration(hours: 6)), 25, 50, "02d"),
    Weather(DateTime.now().add(Duration(hours: 6)), 28, 50, "01d"),
  ];

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
        body: ListView( //Здесь мы передаем список с элементами в конструктор
            children: weatherForcast.map((Weather weather) {
        return WeatherListItem(weather);
        } ).toList()
      )),
    );
  }}



