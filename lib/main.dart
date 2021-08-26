
import 'dart:convert';
import 'package:timezone/standalone.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timezone/timezone.dart';
import 'package:weather_app/location_info.dart';
import 'package:weather_app/weather_page.dart';
import 'constant.dart';
import 'weather.dart';
import 'model/forecast_response.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var byteData = await rootBundle
      .load('packages/timezone/data/2020b.tzf');
  initializeDatabase(byteData.buffer.asUint8List());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return LocationInheritedWidget(
       child:  MaterialApp(
           debugShowCheckedModeBanner: false,
           title: 'Weather report',
           theme: ThemeData(
             primarySwatch: Colors.amber,
           ),
           home: PlacePage()));
  }
}






