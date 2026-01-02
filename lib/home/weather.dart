import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  final double lat;
  final double lon;
  final String systemName;

  const WeatherPage({
    super.key,
    required this.lat,
    required this.lon,
    required this.systemName,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<Map<String, dynamic>> _weatherData;

  @override
  void initState() {
    super.initState();
    _weatherData = fetchWeather();
  }

  Future<Map<String, dynamic>> fetchWeather() async {
    // Open-Meteo API using the passed coordinates
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${widget.lat}&longitude=${widget.lon}&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,wind_speed_10m&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Impossible de charger la météo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A6B3E),
        elevation: 0,
        title: Text("Météo: ${widget.systemName}", style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4A6B3E)));
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else {
            final current = snapshot.data!['current'];
            final daily = snapshot.data!['daily'];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  // WEATHER CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA2C392),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Température", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("${current['temperature_2m']}°C", 
                                style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
                            Text("Max: ${daily['temperature_2m_max'][0]}° Min: ${daily['temperature_2m_min'][0]}°"),
                          ],
                        ),
                        const Icon(Icons.cloud_queue, size: 60, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    children: [
                      _infoCard(Icons.air, "Vent", "${current['wind_speed_10m']} km/h"),
                      _infoCard(Icons.water_drop, "Précip.", "${current['precipitation']} mm"),
                      _infoCard(Icons.sunny, "Soleil", "${daily['sunrise'][0].split('T')[1]}"),
                      _infoCard(Icons.thermostat, "Ressenti", "${current['apparent_temperature']}°C"),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4ED),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF4A6B3E)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}