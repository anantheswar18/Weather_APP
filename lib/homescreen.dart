import 'package:as_weather/constants.dart' as k;
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  bool isLoaded = false;
  num temp = 0;
  num pressure = 0;
  num hum = 0;
  num cover = 0;
  String cityName = '';
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff74ebd5),
                Color(0xffACB6E5),
              ]),
        ),
        child: Visibility(
          visible: isLoaded,
          replacement: const Center(
              child: CircularProgressIndicator(
            strokeWidth: 2,
          )),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.09,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    onFieldSubmitted: (String s) {
                      setState(() {
                        cityName = s;
                        getCityWeather(s);
                        isLoaded = false;
                        controller.clear();
                      });
                    },
                    controller: controller,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search City',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 25,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.pin_drop,
                      color: Colors.red,
                      size: 40,
                    ),
                    Text(
                      cityName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Cards(
                climate: temp,
                imageurl: 'assets/temp.jpeg',
                name: 'Temperature',
                unit: '℃',
              ),
              Cards(
                climate: pressure,
                imageurl: 'assets/baromeater.png',
                name: 'Pressure',
                unit: 'hps',
              ),
              Cards(
                climate: hum,
                imageurl: 'assets/hum.png',
                name: 'Humidity',
                unit: '%',
              ),
              Cards(
                climate: cover,
                imageurl: 'assets/cloudy.jpeg',
                name: 'Cloud Cover',
                unit: '%',
              )
            ],
          ),
        ),
      ),
    ));
  }

  // *****************************************************************Functions******************************************************************

  getCurrentLocation() async {
    var p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    if (p != null) {
      print("Lat:${p.latitude},Long:${p.longitude}");
      getCurrentCityWeather(p);
    } else {
      print("Data unavilable");
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri =
        '${k.domine}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = response.body;
      var decodeData = json.decode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print(response.statusCode);
    }
  }

  getCityWeather(String cityName) async {
    var client = http.Client();
    var uri = '${k.domine}q=$cityName&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = response.body;
      var decodeData = json.decode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
    } else if (response.statusCode == 404) {
      return const Center(
        child: Text(
          "Resource Not Found",
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      print(response.statusCode);
    }
  }

  updateUI(var decodeData) {
    setState(() {
      if (decodeData == null) {
        temp = 0;
        pressure = 0;
        hum = 0;
        cover = 0;
        cityName = 'Not available';
      } else {
        temp = decodeData['main']['temp'] - 273;
        pressure = decodeData['main']['pressure'];
        hum = decodeData['main']['temp'];
        cover = decodeData['clouds']['all'];
        cityName = decodeData['name'];
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
