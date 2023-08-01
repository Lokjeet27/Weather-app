import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/aqi.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final locationWeather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  String weatherIcon;
  String weatherTemp;
  int temperature;
  String cityName;

  AqiCoordinate aqiCoordinate = AqiCoordinate();
  String cityAqi;
  double pm2_5 ;
  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
    updateAqi();
  }
  void updateUI(dynamic weatherData){
    setState(() {
      if(weatherData==null){
        temperature = 0;
        cityName = ' ';
        weatherIcon = 'Error';
        weatherTemp = 'Unable to fetch temperature data';
        return;
      }
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      weatherTemp = weather.getMessage(temperature);
      cityName = weatherData['name'];
      print(temperature);
      print(cityName);
    });
  }
  void updateAqi() async{
    setState(() {
      if(pm2_5 ==null){
        pm2_5 = 0;
      }
    });
    var currentAqi = await aqiCoordinate.getCurrentAqi();
    pm2_5 = currentAqi ['list'][0] ['components']['pm2_5'];
    print(pm2_5);
    String aqiconditon = aqiCoordinate.aqiMeasurePm2_5(pm2_5);
    print(aqiconditon);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async{
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        updateAqi();
                      },
                      child: Icon(
                        Icons.smoking_rooms,
                        size: 50.0,
                      ),
                  ),
                  TextButton(
                    onPressed: () async{
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context){
                            return CityScreen();
                            },
                        ),
                      );
                      cityAqi = typedName;
                      if(typedName!=null) {
                        var weatherData =
                          await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row (
                  children: <Widget> [
                    SfRadialGauge(
                        title:GaugeTitle(text: 'AQI',
                            textStyle: kGaugeTextStyle),
                        axes: <RadialAxis>[
                          RadialAxis(minimum: 0,maximum: 100,
                              ranges: <GaugeRange>[
                                GaugeRange(startValue: 0,endValue: 10,color: Colors.green,startWidth: 10,endWidth: 10),
                                GaugeRange(startValue: 10,endValue: 25,color: Colors.yellow,startWidth: 10,endWidth: 10),
                                GaugeRange(startValue: 25,endValue: 50,color: Colors.orange,startWidth: 10,endWidth: 10),
                                GaugeRange(startValue: 50,endValue: 75,color: Colors.red,startWidth: 10,endWidth: 10),
                                GaugeRange(startValue: 75,endValue: 100,color: Colors.brown,startWidth: 10,endWidth: 10),
                              ],

                              pointers: <GaugePointer> [
                                NeedlePointer(value:pm2_5,animationType: AnimationType.bounceOut,
                                    enableAnimation : true,
                                    animationDuration: 3.0,needleColor: Colors.orange)],

                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(widget: Container(child:
                                Text('$pm2_5',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                                    angle: 90,positionFactor: 0.5)])]),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherTemp in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


