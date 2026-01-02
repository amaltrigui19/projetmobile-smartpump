import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Open-Meteo doesn't need an API key!
  Future<Map<String, dynamic>> getWeatherData() async {
    // Example: London (Lat: 51.5, Long: -0.12)
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=51.5074&longitude=-0.1278&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,wind_speed_10m&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}