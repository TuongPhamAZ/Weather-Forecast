import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.weatherapi.com/v1";
  final String apiKey = "b8f744fca9784340a98174011252203"; // Thay bằng API Key của bạn

  /// Lấy thời tiết hiện tại theo thành phố hoặc tọa độ (lat, lon)
  Future<Map<String, dynamic>> fetchWeather(String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/current.json?key=$apiKey&q=$query"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load weather data: ${response.body}");
    }
  }

  /// Lấy dự báo thời tiết 7 ngày theo thành phố hoặc tọa độ
  Future<Map<String, dynamic>> fetchForecast(String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/forecast.json?key=$apiKey&q=$query&days=14"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load forecast data: ${response.body}");
    }
  }
}
