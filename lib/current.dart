import 'package:flutter/material.dart';

String getVietnameseLocationName(String? name) {
  const vnMap = {
    'Ha Noi': 'Hà Nội',
    'Ho Chi Minh City': 'Thành phố Hồ Chí Minh',
    'Da Nang': 'Đà Nẵng',
    'Hai Phong': 'Hải Phòng',
    'Can Tho': 'Cần Thơ',
    'Nha Trang': 'Nha Trang',
    'Hue': 'Huế',
    'Vung Tau': 'Vũng Tàu',
    'Da Lat': 'Đà Lạt',
    'Phan Thiet': 'Phan Thiết',
  };
  if (name == null) return 'Thời tiết hiện tại';
  return vnMap[name] ?? name;
}

class CurrentWeather extends StatelessWidget {
  final Map<String, dynamic> currentWeather;
  final bool isVietnamese;
  final String Function(String, bool) translateCondition;
  final VoidCallback? onAddLocationPressed;

  const CurrentWeather({
    super.key,
    required this.currentWeather,
    required this.isVietnamese,
    required this.translateCondition,
    this.onAddLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    final temp = currentWeather['temp_c'] ?? '';
    final condition = currentWeather['condition']?['text'] ?? '';
    final iconUrl = currentWeather['condition']?['icon'] ?? '';
    final humidity = currentWeather['humidity'] ?? '';
    final windKph = currentWeather['wind_kph'] ?? '';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isVietnamese
                    ? CurrentWeather.getVietnameseLocationName(
                        currentWeather['location']?['name'])
                    : (currentWeather['location']?['name'] ??
                        'Current Weather'),
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: onAddLocationPressed,
                icon:
                    const Icon(Icons.location_on, size: 28, color: Colors.blue),
                tooltip: isVietnamese ? 'Thay đổi vị trí' : 'Change Location',
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('$temp°C',
              style:
                  const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          if (iconUrl.isNotEmpty)
            Image.network(
              iconUrl.startsWith('//') ? 'https:$iconUrl' : iconUrl,
              width: 64,
              height: 64,
            )
          else
            Icon(Icons.wb_sunny, size: 64, color: Colors.orange),
          const SizedBox(height: 20),
          Text(translateCondition(condition, isVietnamese),
              style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Text('${isVietnamese ? "Độ ẩm" : "Humidity"}: $humidity%',
              style: const TextStyle(fontSize: 16)),
          Text('${isVietnamese ? "Gió" : "Wind"}: $windKph km/h',
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  static String getVietnameseLocationName(String? name) {
    const vnMap = {
      'Ha Noi': 'Hà Nội',
      'Ho Chi Minh City': 'Thành phố Hồ Chí Minh',
      'Da Nang': 'Đà Nẵng',
      'Hai Phong': 'Hải Phòng',
      'Can Tho': 'Cần Thơ',
      'Nha Trang': 'Nha Trang',
      'Hue': 'Huế',
      'Vung Tau': 'Vũng Tàu',
      'Da Lat': 'Đà Lạt',
      'Phan Thiet': 'Phan Thiết',
    };
    if (name == null) return 'Thời tiết hiện tại';
    return vnMap[name] ?? name;
  }
}
