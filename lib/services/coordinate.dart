import 'package:clima/services/networking.dart';
import 'package:geolocator/geolocator.dart';
import 'package:clima/services/location.dart';


class Coordinate{
  double latitude;
  double longitude;

  Future<dynamic> getCoordinate(String cityName) async{
    Location location = Location();
    NetworkHelper networkHelper = NetworkHelper('http://api.openweathermap.org/geo/1.0/direct?'
        'q=$cityName&limit=5&appid={API key}');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

}