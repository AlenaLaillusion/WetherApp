import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/location_info.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
    GoogleMapController _mapController;
    Marker _positionMarker;
    Set<Marker> _markers = HashSet<Marker>();
    Placemark _placemark;

    bool _isLoading = false;
    bool _isReinitingMarker = false;

    LatLng _markerPosition = LatLng(55.7532, 37.6206);

    void _onMapCreated(GoogleMapController controller) {
      _mapController = controller;
    }

    @override
    void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  Widget get _contentView {
      return GoogleMap(
        onMapCreated: _onMapCreated,
          markers: _markers,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _markerPosition,
            zoom: 11.0,),
        onTap: (latLng) => _updatePlaceMark(latLng),
          );
  }

    Widget get _pageToDisplay {
      if (_isLoading) {
        return _loadingView;
      } else {
        return _contentView;
      }
    }

    Widget get _loadingView {
      return Center(
        child: CircularProgressIndicator(), // виджет прогресса
      );
    }

    void _savePlace() {
      Navigator.pop(context, _placemark);
    }


    void _loadData() {
      _isLoading = true;
      initPlaceMark();
      if (_placemark != null) {
        setState(() {
          _markerPosition = LatLng(_placemark.position.latitude,
              _placemark.position.longitude);
          _reInitMarker();
          _isLoading = false;
        });
      }
  }

  //читаем данные о местоположении из InheriteWidget[LocationInfo]
  void initPlaceMark() {
      if(_placemark == null || _placemark?.position == null) {
        //получаем инстанс InheriteWidget
        var locationInfo = LocationInfo.of(context);
        //xитаем оттуда местоположение
        _placemark = locationInfo?.placemark;
      }
  }

    /// готовим объект маркера для отрисовки и добавляем его в список маркеров на карте
    void _reInitMarker() {
      _positionMarker = Marker(
        markerId: MarkerId(_placemark.name),
        position: _markerPosition,
        draggable: true,
        onDragEnd: (latLng) {
          _updatePlaceMark(latLng);
        },
        infoWindow: InfoWindow(
          title: _placemark.subAdministrativeArea,
          snippet: _placemark.toString(),
        ),
      );
      _markers.clear();
      _markers.add(_positionMarker);
      _isReinitingMarker = false;
    }

  //вызываем эту функцию при тапе на карте или перемещении маркера
///обновляем координаты и данные местоположения для маркера
  void _updatePlaceMark(LatLng latlng) {
      if(_isReinitingMarker) {
        return;
      }
      _isReinitingMarker = true;
      setState(() {
        _markerPosition = latlng;
      });
      var placeFuture = LocationHelper.getPlacemark(
        _markerPosition.latitude, _markerPosition.longitude);
      placeFuture.then((newPlaceMark) {
        setState(() {
          _placemark = newPlaceMark;
          _reInitMarker();
        });
      });
  }
}
