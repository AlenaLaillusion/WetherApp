
import 'dart:convert';

import 'package:flutter/material.dart';
import 'constant.dart';
import 'weather.dart';
import 'model/forecast_response.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


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

  return _WeatherForcecastPageState(35.0164, 139.0077);
  }
}

class _WeatherForcecastPageState extends State<WeatherForcecastPage> {

  final _skaffoldKey = GlobalKey<ScaffoldState>();

  final double latitude;
  final double longitude;

  List<ListItem> weatherForcast;
  _WeatherForcecastPageState(this.latitude, this.longitude);

  Future<List<ListItem>> getWeather(double lat, double lng) async {
    var queryParameters = { //подготавливаем параметры запроса
      'appid': Constants.WEATHER_APP_ID,
      'units': 'metric',
      'lat': lat.toString(),
      'lon': lng.toString(),
    };
    var uri = Uri.https(Constants.WEATHER_BASE_URL,
       Constants.WEATHER_FORECAST_URL, queryParameters);

    var response = await http.get(uri); //выполняем запрос и ждем результат
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var forecastResponseEntity = ForecastResponse.fromMap(json.decode(response.body));
      if ( forecastResponseEntity.cod == "200") {//в случае успеха парси Json и возвращаем список с прогнозом
        print(forecastResponseEntity.list);
        return forecastResponseEntity.list;
      } else {
        //в случае ошибки показываем ошибку
        print("Error ${forecastResponseEntity.cod}");
      }
    } else {
      //в случае ошибки показываем ошибку
    print("Error occured while loading data from server");
    }
    return List<ListItem>();
  }

  @override
  void initState() {
    var itCurrentDay = DateTime.now();
   var dataFuture = getWeather(latitude, longitude);
   dataFuture.then((value) {
     var weatherForecastLocal = List<ListItem>();
     weatherForecastLocal.add(DayHeading(itCurrentDay)); // first heading
     List<ListItem> weatherData = value;
     var itNextDay = DateTime.now().add(Duration(days: 1));
     itNextDay = DateTime(
         itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
     var iterator = weatherData.iterator;
     while (iterator.moveNext()) {
       var weatherDateTime = iterator.current as WeatherListBean;
       if (weatherDateTime.getDateTime().isAfter(itNextDay)) {
         itCurrentDay = itNextDay;
         itNextDay = itCurrentDay.add(Duration(days: 1));
         itNextDay = DateTime(
             itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
         weatherForecastLocal.add(DayHeading(itCurrentDay)); // next heading
       } else {
         weatherForecastLocal.add(iterator.current);
       }
     }
       setState(() {
       weatherForcast = weatherForecastLocal;
   });
   });
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
          itemCount: weatherForcast == null ? 0 : weatherForcast.length,
            itemBuilder: (BuildContext context, int index) {
            final item = weatherForcast[index];
            if (item is WeatherListBean) {
              return WeatherListItem(item);
            } else if(item is DayHeading) {
              return HeadingListItem(item);
            } else
            throw Exception('wrong type');
            }
        )));
  }}

/*
Future<Placemark> getLocation() async {
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  Position position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low); //получение геопозиции
  List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude); //определение названия места
  if(placemark.isNotEmpty) {
    return placemark[0]; //возвращаем первый элемент из списка полученных вариантов
  }
  return null;
}

void _loadData() {
  _isLoading = true;
  var locationFuture = getLocation(); //получение future на геопозицию
  locationFuture.then((placemark) { //берем значение из результата
    var weatherFuture = getWeather(placemark.position.latitude, placemark.position.longitude); // делаем запрос на получение погоды
    weatherFuture.then((weatherData) {
      initWeatherWithData(weatherData, placemark);
      _isLoading = false;
    });
  });
}

*/




