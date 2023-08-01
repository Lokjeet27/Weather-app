import 'package:clima/services/networking.dart';
import 'package:clima/services/weather.dart';

const appkey = '3527417dba72fae7f6cc6d5d5d337660';

class AqiCoordinate{
  double latitude;
  double longitude;


  Future<dynamic> getCurrentAqi() async{
    WeatherModel weatherModel = WeatherModel();
    var weatherAqi = await weatherModel.getLocationWeather();
    latitude = weatherAqi['coord']['lat'];
    longitude = weatherAqi['coord']['lon'];
    NetworkHelper networkHelper = NetworkHelper('http://api.openweathermap.org/data/2.5/air_pollution?'
        'lat=$latitude&lon=$longitude&appid=$appkey');
    var weatherData = await networkHelper.getData();
    print(weatherData);
    return weatherData;
  }

  String aqiMeasurePm2_5(double pm2_5){
    if(pm2_5<10){
      return 'Good';
    }else if(pm2_5<25){
      return 'Fair';
    }else if(pm2_5<50){
      return 'Moderate';
    }else if(pm2_5<75){
      return 'Poor';
    }else{
      return 'Very Poor';
    }
  }
}



