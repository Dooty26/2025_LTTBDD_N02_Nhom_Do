import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationModel {
  final String name;
  final String displayName;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  LocationModel({
    required this.name,
    required this.displayName,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'displayName': displayName,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isDefault: json['isDefault'] ?? false,
    );
  }
}

class LocationService {
  Future<List<LocationModel>> searchLocation(String query) async {
    final apiKey = '1a4b4191438544af8e7142923250411';
    final url =
        'https://api.weatherapi.com/v1/search.json?key=$apiKey&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => LocationModel(
                name: json['name'] ?? '',
                displayName: json['name'] ?? '',
                latitude: json['lat']?.toDouble(),
                longitude: json['lon']?.toDouble(),
                isDefault: false,
              ))
          .toList();
    } else {
      throw Exception('Không thể tìm kiếm vị trí');
    }
  }

  Future<LocationModel?> getDeviceLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LocationModel(
      name: '${position.latitude},${position.longitude}',
      displayName: 'Vị trí hiện tại',
      latitude: position.latitude,
      longitude: position.longitude,
      isDefault: false,
    );
  }
}

Future<LocationModel?> getDeviceLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return LocationModel(
    name: '${position.latitude},${position.longitude}',
    displayName: 'Vị trí hiện tại',
    latitude: position.latitude,
    longitude: position.longitude,
    isDefault: false,
  );
}
