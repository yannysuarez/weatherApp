import 'package:flutter/material.dart';
import 'package:test_clima_flutter/screens/city_screen.dart';
import 'package:test_clima_flutter/utilities/constants.dart';
import 'dart:convert';
import 'package:test_clima_flutter/services/weather.dart';
import 'package:test_clima_flutter/screens/city_screen.dart';

import '../services/networking.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen(this.data, {super.key});
  String data;


  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String city = '', icon = '', message = '';
  int temperature = 0;
  int id = 0;

  @override
  void initState() {
    super.initState();
    updateUI(widget.data);
  }

  void updateUI(dynamic data) {
    setState(() {
      if (data == null) {
        city = 'city';
        icon = 'Error';
        message = 'Cannot find data';
        temperature = 0;
        return;
      }
      city = jsonDecode(data)['name'];
      double temp = jsonDecode(data)['main']['temp'];
      temperature = temp.toInt();
      id = jsonDecode(data)['weather'][0]['id'];

      WeatherModel weatherModel = new WeatherModel();
      icon = weatherModel.getWeatherIcon(id);
      message = weatherModel.getMessage(temperature);
      // for debugging
      print("City: $city\nTemp: $temp\nID: $id");
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var data = await Networking().getLocationData();
                      updateUI(data);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async{
                      String newcity='';
                      newcity = await Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CityScreen();
                      }));
                        if (newcity != null) {
                          dynamic weather =
                          await Networking().getCityData(newcity);
                          updateUI(weather);
                           }
                        },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Visibility(
                      visible: temperature != 0,
                         child: Text(
                      temperature.toStringAsFixed(0) + '°',
                      style: kTempTextStyle,
                    ),
                    ),
                    Text(
                      icon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message in $city!",
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


