import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(DevicePreview(builder: (_) => MyWeatherDressApp()));
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

  final String _city = "Peddāpuram";
  late final String _apiKey;

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

  // Outfit suggestions based on gender & temperature
  List<Map<String, String>> getOutfitSuggestions() {
    if (_gender == "male") {
      if (_temperature >= 30) {
        return [
          {
            "title": "Casual Linen Shirt & Shorts",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmmevJGJxCKMi1NAhDTkmxW-kNy20WoR7lMQ&s",
          },
          {
            "title": "Sleeveless Tank & Sunglasses",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCXUgJKR_dms1FyhgyRXpTcx__lwIzbjmNWg&s",
          },
        ];
      } else if (_temperature >= 20) {
        return [
          {
            "title": "Denim Jacket + T-Shirt",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjXwycBVuJ58oD7BbxAoPidOYUkzgN2iv_qQ&s",
          },
          {
            "title": "Casual Hoodie & Jeans",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfayDO7U4W36dIXDMU-3w79fkmN1Ao7U_XXw&s",
          },
        ];
      } else if (_temperature >= 10) {
        return [
          {
            "title": "Wool Sweater & Beanie",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1AdZUgIZKQ_mnpM4pgZiSWb7g-yJ_94XT8Q&s",
          },
          {
            "title": "Layered Hoodie + Jacket",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSkr5T41xPCfjYk45GeLi4diekasHaRdkG3w&s",
          },
        ];
      } else {
        return [
          {
            "title": "Puffer Jacket & Gloves",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6wOrhU2i1-JU6WRv4P0dAjElF_lIdLSqjoQ&s",
          },
          {
            "title": "Heavy Coat + Scarf",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzyZeGOoGqtvhjL5Sk7zSTNbnp_iuv3OaUPA&s",
          },
        ];
      }
    } else {
      if (_temperature >= 30) {
        return [
          {
            "title": "Summer Dress & Sunglasses",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1aD8BMhSZTbebEzwo58CU0ZZAkDZ6YAdZbw&s",
          },
          {
            "title": "Tank Top + Skirt",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkZFaxmq7yRGAdBeLv8rfMFrplcHpcDviWYA&s",
          },
        ];
      } else if (_temperature >= 20) {
        return [
          {
            "title": "Light Cardigan + Jeans",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQksRhCM_S2OfTag770nbXL5BtuxSvP0CgPlQ&s",
          },
          {
            "title": "Long Sleeve Blouse + Skirt",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQF3w6XlgUJrXCdy_DkDb0_UKauxTlNvctn0g&s",
          },
        ];
      } else if (_temperature >= 10) {
        return [
          {
            "title": "Wool Coat + Scarf",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDjjb4NOx5hlGCw1kHczKmkWTjlIfBzX0YRg&s",
          },
          {
            "title": "Knit Sweater & Jeans",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxboon0ln3mTS85YL9UOB3nMj-JFYuYCb-Tw&s",
          },
        ];
      } else {
        return [
          {
            "title": "Puffer Jacket & Boots",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4vXjIY6LOVj3gLzy3m6ticzBYACERk386tQ&s",
          },
          {
            "title": "Layered Thermal Wear",
            "imageUrl":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQaLHV2xOkl2x3cwzsNN6U2VJ3TM4fwULgygA&s",
          },
        ];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Dress Suggestion',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              height: 80,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset("assets/temptogs_logo.png", fit: BoxFit.cover),
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              "TempTogs",
              style: TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
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
                  Expanded(child: _buildOutfitSection()),
                ],
              ),
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 80, bottom: 30),
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
    String label,
    String gender,
    Color lightColor,
    Color darkColor,
  ) {
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

  // Outfits Grid
  Widget _buildOutfitSection() {
    final outfits = getOutfitSuggestions();
    return GridView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
      ),
      itemCount: outfits.length,
      itemBuilder: (context, index) {
        final outfit = outfits[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.black45 : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  outfit["imageUrl"] ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
              SizedBox(height: 8),
              Text(
                outfit["title"] ?? "Unknown",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.cloud, color: Colors.blue),
                  SizedBox(width: 2),
                  Text("${_temperature.toStringAsFixed(0)}°C",
                      style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
