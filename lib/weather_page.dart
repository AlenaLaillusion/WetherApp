
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/model/weather_forest_page.dart';
import 'map_page.dart';


class PlacePage extends StatefulWidget {
  const PlacePage({Key key}) : super(key: key);

  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {

  //gtрвоначальный тестовый список
  List<Placemark> _places = [
    Placemark(
      name: 'Moskow',
      country: 'Europe',
      administrativeArea: 'Moskow',
      position: Position(longitude: 37.6206, latitude: 55.7532)),
    Placemark(
        name: 'Paris',
        country: 'Europe',
        administrativeArea: 'Paris',
        position: Position(longitude: 2.2950, latitude: 48.8753)),
    Placemark(
        name: 'London',
        country: 'Europe',
        administrativeArea: 'London',
        position: Position(longitude: -0.1254, latitude: 51.5011)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places'),
      ),
      body: Column(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: InkWell(
                    onTap: () => _onItemTapped(null),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                     child: Text("Current position",
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),),
                    ),
                  )
              )
            ],),
        Divider(
          height: 4,
          thickness: 2,
        ),
        Expanded(
            child: ListView.builder(
              itemCount: _places.length,
                itemBuilder: (context, index) {
                final place = _places[index];
                return Dismissible(
                    key: Key(place.name),
                    onDismissed: (direction) {
                      setState(() {
                        _places.removeAt(index);
                      });
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("$place removed")));
                  },
                  background: Container (
                  color: Colors.red,
                  ),
                  child: ListTile(
                  title: Text(_preparePlaceTitle(place)),
                  onTap: () => _onItemTapped(place),
                  ),
                );
                },
            ))
      ],),
    );
  }

  //генерирует название места на основе объекта (placemark)
  String _preparePlaceTitle(Placemark placemark) {
    var placeTitle = "";
    if(placemark.country != null) {
      placeTitle = placemark.country;
    }
    if (placemark.administrativeArea !=null) {
      placeTitle = placeTitle + ", " + placemark.administrativeArea;
    } else if (placemark.name != null) {
      placeTitle = placeTitle + ", " + placemark.name;
    }
    return placeTitle;
  }

  //обработчик нажатия на элемент списа - переход на экран погоды
  void _onItemTapped(Placemark place) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
        WeatherForecastPage(place)),
    );
  }

  //обработчик нажатия на плавающую кнопку - добавление нового места
  void _onAddNew() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapPage()),
    ); //ждем добавленное место

    setState(() {
      if(result != null) {
        _places.add(result);
      }
    });
  }
}
