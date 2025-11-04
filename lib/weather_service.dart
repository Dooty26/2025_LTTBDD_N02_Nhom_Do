import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '1a4b4191438544af8e7142923250411';

  Future<Map<String, dynamic>> getCurrentWeather(
      String city) async {
    final url =
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['current'];
    } else {
      throw Exception('Lỗi lấy dữ liệu thời tiết hiện tại');
    }
  }

  Future<List<dynamic>> fetch7DayForecast(
      String city) async {
    final url =
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['forecast']['forecastday'];
    } else {
      throw Exception('Lỗi lấy dữ liệu dự báo 7 ngày');
    }
  }

  Future<List<dynamic>> fetch24HourForecast(
      String city) async {
    final url =
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=1&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['forecast']['forecastday'][0]['hour'];
    } else {
      throw Exception('Lỗi lấy dữ liệu dự báo 24 giờ');
    }
  }
}
