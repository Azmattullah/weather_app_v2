import 'package:flutter/material.dart';
import 'package:weather_app_v2/models/weather_model.dart';
import 'package:weather_app_v2/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

bool _iconBool = false;
IconData _iconLight = Icons.wb_sunny;
IconData _iconDark = Icons.nights_stay;

ThemeData _lightTheme = ThemeData(
  // primarySwatch: Colors.black,
  brightness: Brightness.light,
);

ThemeData _darkTheme = ThemeData(
  // primarySwatch: Colors.red,
  brightness: Brightness.dark,
);

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('8dde22f249629fa2b295d6ce68ded4f9');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    // any errors
    catch (e) {
      print(e);
    }
  }

// weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/cloud.png'; //default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloud.png';
      case 'mist':
        return 'assets/fog.png';
      case 'smoke':
        return 'assets/smoke.png';
      case 'haze':
        return 'assets/haze.png';
      case 'dust':
        return 'assets/sand.png';
      case 'fog':
        return 'assets/fog.png';
      case 'rain':
        return 'assets/rain.png';
      case 'drizzle':
        return 'assets/drizzle.png';
      case 'shower rain':
        return 'assets/rain.png';
      case 'thunderstorm':
        return 'assets/thunderstrom.png';
      case 'clear':
        return 'assets/clear.png';
      default:
        return 'assets/cloud.png';
    }
  }

// init state
  @override
  void initState() {
    super.initState();
    // fetch weateher on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _iconBool ? _darkTheme : _lightTheme,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Weather App', style: TextStyle(fontSize: 25),),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {
              setState(() {
                _iconBool = !_iconBool;
              });
            }, icon: Icon(_iconBool ? _iconDark : _iconLight),),
          ],
        ),
        // backgroundColor: Colors.amber[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 30),
              // city name
              Text(_weather?.cityName ?? "loading city...",
                  style: TextStyle(fontSize: 40, color: Colors.grey.shade500)),
              SizedBox(height: 70),
              // animation
              // Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              Image.asset(
                getWeatherAnimation(_weather?.mainCondition ?? 'Unknown'),
                height: 280, // Set the desired height
                width: 280, // Set the desired width
              ),
              SizedBox(height: 50),
              // temperature
              Text('${_weather?.temperature.round()} °C',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  )),
              // weather condition
              SizedBox(height: 15),
              Text(
                _weather?.mainCondition ?? "",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pressure: ${_weather?.pressure.round()}mb',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text('Humidity: ${_weather?.humidity.round()}%',
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
