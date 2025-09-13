import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temptogs/theme_provider.dart';

import 'weather_header.dart';
import 'outfit_card.dart';
import 'favorites_screen.dart';
import 'outfit_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool _isDarkMode = false;
  String _gender = "male";
  double _temperature = 0.0;
  String _weatherCondition = "";
  String _city = "Kakinada";
  bool _loading = true;
  late final String _apiKey;

  int _selectedIndex = 0;
  List<Map<String, String>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _apiKey = dotenv.env['API_KEY'] ?? "";
    _loadFavorites();
    fetchWeather(_city);
  }

  // SharedPreferences persistence
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList('favorites') ?? [];
    setState(() {
      _favorites =
          list
              .map((s) => Map<String, String>.from(json.decode(s) as Map))
              .toList();
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _favorites.map((m) => json.encode(m)).toList();
    await prefs.setStringList('favorites', encoded);
  }

  Future<void> fetchWeather(String city) async {
    setState(() {
      _loading = true;
      _city = city;
    });

    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric",
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
      } else if (response.statusCode == 404) {
        setState(() => _loading = false);
        // _showSnack("City not found. Try another name.", isError: true);
      } else {
        setState(() => _loading = false);
        _showSnack("Error ${response.statusCode}", isError: true);
      }
    } catch (e) {
      setState(() => _loading = false);
      _showSnack("Network error. Check connection.", isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  // Toggle & persist (prevents duplicates using title as unique key)
  void _toggleFavorite(Map<String, String> outfit) {
    final title = outfit['title'] ?? "";
    final exists = _favorites.any((f) => f['title'] == title);

    setState(() {
      if (exists) {
        _favorites.removeWhere((f) => f['title'] == title);
        _showSnack('Removed "$title" from favorites');
      } else {
        _favorites.add(outfit);
        _showSnack('Saved "$title" to favorites');
      }
    });

    _saveFavorites();
  }

  void _clearAllFavorites() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Clear all favorites?"),
            content: const Text("This will remove all saved outfits."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _favorites.clear());
                  _saveFavorites();
                  Navigator.pop(ctx);
                  _showSnack("All favorites cleared");
                },
                child: const Text("Clear", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // Suggestions: multi-image support (comma separated)
  List<Map<String, String>> getOutfitSuggestions() {
    // working Unsplash images (multiple images separated by comma)
    if (_gender == "male") {
      if (_temperature >= 30) {
        return [
          {
            "title": "Linen Shirt & Shorts",
            "imageUrl":
                "https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?w=1200&auto=format,compress,https://images.unsplash.com/photo-1495121605193-b116b5b09cf1?w=1200&auto=format,compress",
          },
          {
            "title": "Tank & Sunglasses",
            "imageUrl":
                "https://images.unsplash.com/photo-1504593811423-6dd665756598?w=1200&auto=format,compress,https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=1200&auto=format,compress",
          },
        ];
      } else if (_temperature >= 20) {
        return [
          {
            "title": "Denim Jacket & Tee",
            "imageUrl":
                "https://images.unsplash.com/photo-1520975867597-3a2cda9d45d9?w=1200&auto=format,compress",
          },
          {
            "title": "Hoodie & Jeans",
            "imageUrl":
                "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=1200&auto=format,compress",
          },
        ];
      } else if (_temperature >= 10) {
        return [
          {
            "title": "Wool Sweater & Beanie",
            "imageUrl":
                "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200&auto=format,compress",
          },
          {
            "title": "Layered Hoodie",
            "imageUrl":
                "https://images.unsplash.com/photo-1519744792095-2f2205e87b6f?w=1200&auto=format,compress",
          },
        ];
      } else {
        return [
          {
            "title": "Puffer Jacket & Gloves",
            "imageUrl":
                "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=1200&auto=format,compress",
          },
          {
            "title": "Heavy Coat & Scarf",
            "imageUrl":
                "https://images.unsplash.com/photo-1540574163026-643ea20ade25?w=1200&auto=format,compress",
          },
        ];
      }
    } else {
      if (_temperature >= 30) {
        return [
          {
            "title": "Summer Dress & Sunglasses",
            "imageUrl":
                "https://images.unsplash.com/photo-1495121605193-b116b5b09cf1?w=1200&auto=format,compress",
          },
          {
            "title": "Tank Top & Skirt",
            "imageUrl":
                "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=1200&auto=format,compress",
          },
        ];
      } else if (_temperature >= 20) {
        return [
          {
            "title": "Light Cardigan + Jeans",
            "imageUrl":
                "https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=1200&auto=format,compress",
          },
          {
            "title": "Long Sleeve Blouse",
            "imageUrl":
                "https://images.unsplash.com/photo-1519741497674-611481863552?w=1200&auto=format,compress",
          },
        ];
      } else if (_temperature >= 10) {
        return [
          {
            "title": "Wool Coat + Scarf",
            "imageUrl":
                "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=1200&auto=format,compress",
          },
          {
            "title": "Knit Sweater & Jeans",
            "imageUrl":
                "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=1200&auto=format,compress",
          },
        ];
      } else {
        return [
          {
            "title": "Puffer Jacket & Boots",
            "imageUrl":
                "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=1200&auto=format,compress",
          },
          {
            "title": "Layered Thermal Wear",
            "imageUrl":
                "https://images.unsplash.com/photo-1503342217505-b0a15b6c3b3e?w=1200&auto=format,compress",
          },
        ];
      }
    }
  }

  // OPEN detail from favorites list
  void _openDetailFromFavorites(Map<String, String> outfit) async {
    final isFav = _favorites.any((f) => f['title'] == outfit['title']);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => OutfitDetailScreen(
              outfit: outfit,
              isFavorite: isFav,
              onToggleFavorite: _toggleFavorite,
            ),
      ),
    );
    // ensure UI is updated after return
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final body =
        _loading
            ? const Center(child: CircularProgressIndicator())
            : (_selectedIndex == 0
                ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      WeatherHeader(
                        city: _city,
                        temp: _temperature,
                        condition: _weatherCondition,
                        isDarkMode: _isDarkMode,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter city name",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) fetchWeather(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            _genderButton(
                              "MALE",
                              "male",
                              Colors.blue,
                              Colors.blueAccent,
                            ),
                            _genderButton(
                              "FEMALE",
                              "female",
                              Colors.pink,
                              Colors.pinkAccent,
                            ),
                          ],
                        ),
                      ),
                      GridView.builder(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.65,
                            ),
                        itemCount: getOutfitSuggestions().length,
                        itemBuilder: (context, index) {
                          final outfit = getOutfitSuggestions()[index];
                          final isFav = _favorites.any(
                            (f) => f['title'] == outfit['title'],
                          );
                          return OutfitCard(
                            outfit: outfit,
                            isFavorite: isFav,
                            onToggleFavorite: () {
                              _toggleFavorite(outfit);
                            },
                            onOpenDetail: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => OutfitDetailScreen(
                                        outfit: outfit,
                                        isFavorite: isFav,
                                        onToggleFavorite: _toggleFavorite,
                                      ),
                                ),
                              );
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
                : FavoritesScreen(
                  favorites: _favorites,
                  onRemove: (o) => _toggleFavorite(o),
                  onClearAll: _clearAllFavorites,
                  onOpen: _openDetailFromFavorites,
                ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("TempTogs"),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),

          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => fetchWeather(_city),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? lightColor : Colors.transparent,
            borderRadius:
                gender == "male"
                    ? const BorderRadius.horizontal(left: Radius.circular(20))
                    : const BorderRadius.horizontal(right: Radius.circular(20)),
            border: Border.all(color: lightColor),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color:
                    isSelected
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
}
