import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  double longitude ;
  double latitude ;
  @override
  void initState() {
    super.initState();
    getlocationData();
  }
  void getlocationData() async{
    WeatherModel weatherModel = WeatherModel();
    var weatherData = await weatherModel.getLocationWeather();
    Navigator.push(context, MaterialPageRoute(builder: (content){
      return LocationScreen(locationWeather: weatherData);
    }));
    // 'https://api.openweathermap.org/data/2.5/weather?'
    //     'lat=${location.latitude}&lon=${location.longitude}}&appid=$appkey&units=metric'
  }
  @override
  Widget build(BuildContext context) {
    getlocationData();
    return Scaffold(
      body: SpinKitDoubleBounce(
        color: Colors.white,
        size: 100.0,
      ),
    );
  }
}

