import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';


const appkey = '3527417dba72fae7f6cc6d5d5d337660';
const openWeatherURL = 'https://api.openweathermap.org/data/2.5/';
//'https://api.openweathermap.org/data/2.5/weather?';

class WeatherModel {

  Future<dynamic> getCityWeather(String cityName) async{
    NetworkHelper networkHelper = NetworkHelper
      ('$openWeatherURL'
        'weather?'
        'q=$cityName&appid=$appkey&units=metric');
    var weatherData = await networkHelper.getData();
    print(weatherData);
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async{
    Location location = Location();
    //waiting to get value;
    //change the datatype to Future in getCurrentLocation method to be appropiate
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper('$openWeatherURL'
        'weather?'
        'lat=${location.latitude}&lon=${location.longitude}&appid=$appkey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }


  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
