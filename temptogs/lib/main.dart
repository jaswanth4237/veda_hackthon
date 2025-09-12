import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp( DevicePreview(builder: (_)=>MyWeatherDressApp()));
}

class MyWeatherDressApp extends StatefulWidget {
  const MyWeatherDressApp({super.key});

  @override
  State<MyWeatherDressApp> createState() => _MyWeatherDressAppState();
}

class _MyWeatherDressAppState extends State<MyWeatherDressApp> {
  bool _isDarkMode = false;
  String _gender = "male";
  double _temperature = 0.0;
  String _weatherCondition = "";
  bool _loading = true;
  String _city = "Peddāpuram"; 

  
   String _apiKey = "9904df81bf81fa460059a801ff1bc4b2";

  @override
  void initState() {
    super.initState();
    _apiKey = dotenv.env['API_KEY'] ?? "";
    fetchWeather(_city);
  }

  Future<void> fetchWeather(String cityName) async {
    setState(() => _loading = true);

    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = (data['main']['temp'] as num).toDouble();
          _weatherCondition = data['weather'][0]['main'];
          _loading = false;
        });
      } else {
        setState(() {
          _weatherCondition = "Error: ${response.statusCode}";
          _loading = false;
        });
      }
    } catch (_) {
      setState(() {
        _weatherCondition = "Error fetching weather";
        _loading = false;
      });
    }
  }

  List<Map<String, String>> getOutfitSuggestions() {
    if (_gender == "male") {
      if (_temperature >= 30) {
        return [
          {
            "title": "Light Tee & Shorts (Male)",
            "imageUrl": "https://example.com/male_hot_tee_shorts.jpg",
          },
          {
            "title": "Sporty Tank Top",
            "imageUrl": "https://example.com/male_tank_top.jpg",
          },
        ];
      } else if (_temperature >= 20) {
        return [
          {
            "title": "Polo Shirt & Chinos",
            "imageUrl": "https://example.com/male_polo_chinos.jpg",
          },
          {
            "title": "Long Sleeve + Light Jacket",
            "imageUrl": "https://example.com/male_long_sleeve.jpg",
          },
        ];
      } else if (_temperature >= 10) {
        return [
          {
            "title": "Sweater + Jacket",
            "imageUrl": "https://example.com/male_sweater_jacket.jpg",
          },
          {
            "title": "Beanie Hat & Scarf",
            "imageUrl": "https://example.com/male_beanie_scarf.jpg",
          },
        ];
      } else {
        return [
          {
            "title": "Heavy Coat & Gloves",
            "imageUrl": "https://example.com/male_heavy_coat.jpg",
          },
          {
            "title": "Thermal Layers",
            "imageUrl": "https://example.com/male_thermal_layers.jpg",
          },
        ];
      }
    } else {
      if (_temperature >= 30) {
        return [
          {
            "title": "Sleeveless Dress or Skirt",
            "imageUrl": "https://example.com/female_hot_dress.jpg",
          },
          {
            "title": "Crop Top & Shorts",
            "imageUrl": "https://example.com/female_crop_shorts.jpg",
          },
        ];
      } else if (_temperature >= 20) {
        return [
          {
            "title": "Blouse + Jeans / Skirt",
            "imageUrl": "https://example.com/female_blouse_jeans.jpg",
          },
          {
            "title": "Long Sleeve Dress",
            "imageUrl": "https://example.com/female_long_dress.jpg",
          },
        ];
      } else if (_temperature >= 10) {
        return [
          {
            "title": "Cardigan + Scarf",
            "imageUrl": "https://example.com/female_cardigan_scarf.jpg",
          },
          {
            "title": "Knit Sweater + Jacket",
            "imageUrl": "https://example.com/female_knit_jacket.jpg",
          },
        ];
      } else {
        return [
          {
            "title": "Warm Coat + Boots",
            "imageUrl": "https://example.com/female_heavy_coat_boots.jpg",
          },
          {
            "title": "Layered Thermal Outfit",
            "imageUrl": "https://example.com/female_thermal_outfit.jpg",
          },
        ];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Dress Suggestion',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Weather & Outfit"),
          actions: [
            Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            Switch(
              value: _isDarkMode,
              onChanged: (val) => setState(() => _isDarkMode = val),
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildWeatherHeader(),
                  const SizedBox(height: 20),
                  _buildGenderToggle(),
                  const SizedBox(height: 20),
                  _buildOutfitSection(),
                ],
              ),
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: kToolbarHeight + 20, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkMode
              ? [Colors.blueGrey.shade900, Colors.grey.shade800]
              : [Colors.blue.shade300, Colors.lightBlue.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Text(
            _city,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${_temperature.toStringAsFixed(0)}°C",
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w300,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _weatherCondition,
            style: TextStyle(
              fontSize: 24,
              color: _isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          _genderButton("MALE", "male", Colors.blue, Colors.blueAccent),
          _genderButton("FEMALE", "female", Colors.pink, Colors.pinkAccent),
        ],
      ),
    );
  }

  Widget _genderButton(
      String label, String gender, Color lightColor, Color darkColor) {
    final isSelected = _gender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (_isDarkMode ? darkColor : lightColor)
                : Colors.transparent,
            borderRadius: gender == "male"
                ? const BorderRadius.horizontal(left: Radius.circular(20))
                : const BorderRadius.horizontal(right: Radius.circular(20)),
            border: Border.all(color: _isDarkMode ? darkColor : lightColor),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (_isDarkMode ? Colors.white70 : Colors.black),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutfitSection() {
    final outfits = getOutfitSuggestions();
    return Expanded(
      child: ListView.builder(
        itemCount: outfits.length,
        itemBuilder: (context, index) {
          final outfit = outfits[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(outfit["title"]!),
              leading: Image.network(outfit["imageUrl"]!),
            ),
          );
        },
      ),
    );
  }
}
