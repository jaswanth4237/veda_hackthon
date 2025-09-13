import 'package:flutter/material.dart';

class WeatherHeader extends StatelessWidget {
  final String city;
  final double temp;
  final String condition;
  final bool isDarkMode;

  const WeatherHeader({
    super.key,
    required this.city,
    required this.temp,
    required this.condition,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final isDayTime = hour >= 6 && hour < 18;

    IconData weatherIcon;
    if (condition.contains("Rain")) {
      weatherIcon = Icons.umbrella;
    } else if (condition.contains("Cloud")) {
      weatherIcon = Icons.cloud;
    } else {
      weatherIcon = Icons.wb_sunny;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.blueGrey.shade900, Colors.grey.shade800]
              : isDayTime
                  ? [Colors.blue.shade300, Colors.lightBlue.shade100]
                  : [Colors.indigo.shade700, Colors.black87],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Text(city, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
          const SizedBox(height: 10),
          Icon(weatherIcon, size: 48, color: isDarkMode ? Colors.white70 : Colors.orangeAccent),
          const SizedBox(height: 10),
          Text("${temp.toStringAsFixed(0)}°C", style: TextStyle(fontSize: 64, fontWeight: FontWeight.w300, color: isDarkMode ? Colors.white : Colors.black)),
          const SizedBox(height: 10),
          Text(condition, style: TextStyle(fontSize: 24, color: isDarkMode ? Colors.white70 : Colors.black87)),
        ],
      ),
    );
  }
}
