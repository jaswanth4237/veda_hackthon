import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(DevicePreview(builder : (context)=>MyWeatherDressApp()));
}

class MyWeatherDressApp extends StatefulWidget {
  @override
  _MyWeatherDressAppState createState() => _MyWeatherDressAppState();
}

class _MyWeatherDressAppState extends State<MyWeatherDressApp> {
  bool _isDarkMode = false;
  String _gender = "male"; 
  double _temperature = 0.0;
  String _weatherCondition = "";
  bool _loading = true;
  String _city = "Peddāpuram"; 

  
  final String _apiKey = "9904df81bf81fa460059a801ff1bc4b2";

  @override
  void initState() {
    super.initState();
    fetchWeather(_city);
  }

  Future<void> fetchWeather(String cityName) async {
    setState(() {
      _loading = true;
    });
    try {
      // units=metric gives temp in Celsius
      final url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        double temp = data['main']['temp'].toDouble();
        String condition = data['weather'][0]['main'];
        setState(() {
          _temperature = temp;
          _weatherCondition = condition;
          _loading = false;
        });
      } else {
        setState(() {
          _weatherCondition = "Error: ${response.statusCode}";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _weatherCondition = "Error fetching weather";
        _loading = false;
      });
    }
  }

  String getDressSuggestion() {
    final temp = _temperature;
    if (temp >= 30) {
      return (_gender == "male")
          ? "Wear a light T-shirt & shorts"
          : "Wear a light dress or tank top and skirt";
    } else if (temp >= 20) {
      return (_gender == "male")
          ? "Wear a long-sleeve shirt or polo"
          : "Wear a light blouse with jeans or skirt";
    } else if (temp >= 10) {
      return (_gender == "male")
          ? "Wear a sweater and light jacket"
          : "Wear a sweater or cardigan with scarf";
    } else {
      return (_gender == "male")
          ? "Wear a heavy coat, boots, gloves"
          : "Wear a warm coat, scarf, boots";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Dress Suggestion',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Weather & Dress Suggestion"),
          actions: [
            Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            Switch(
              value: _isDarkMode,
              onChanged: (val) {
                setState(() {
                  _isDarkMode = val;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _loading
                ? CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Weather information
                      Text(
                        _city,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${_temperature.toStringAsFixed(1)}°C",
                        style: TextStyle(fontSize: 64, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _weatherCondition,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 30),

                      // Gender selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: Text('Male'),
                            selected: _gender == "male",
                            onSelected: (selected) {
                              setState(() {
                                if (selected) _gender = "male";
                              });
                            },
                          ),
                          SizedBox(width: 16),
                          ChoiceChip(
                            label: Text('Female'),
                            selected: _gender == "female",
                            onSelected: (selected) {
                              setState(() {
                                if (selected) _gender = "female";
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Dress suggestion
                      Text(
                        getDressSuggestion(),
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}