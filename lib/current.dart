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
    final uv = currentWeather['uv'] ?? '';

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(90, 255, 255, 255),
            Color.fromARGB(70, 255, 255, 255),
            Color.fromARGB(60, 33, 150, 243),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color.fromARGB(120, 255, 255, 255),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(40, 0, 0, 0),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: const Color.fromARGB(50, 255, 255, 255),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  isVietnamese
                      ? CurrentWeather.getVietnameseLocationName(
                          currentWeather['location']?['name'])
                      : (currentWeather['location']?['name'] ??
                          'Current Weather'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(100, 33, 150, 243),
                      Color.fromARGB(80, 25, 118, 210),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromARGB(100, 255, 255, 255),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: onAddLocationPressed,
                  icon: const Icon(Icons.location_on,
                      color: Colors.white, size: 20),
                  tooltip: isVietnamese ? 'Thay đổi vị trí' : 'Change Location',
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$temp',
                style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const Text(
                '°C',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (iconUrl.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(80, 255, 255, 255),
                    Color.fromARGB(60, 33, 150, 243),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color.fromARGB(100, 255, 255, 255),
                  width: 1.5,
                ),
              ),
              child: Image.network(
                iconUrl.startsWith('//') ? 'https:$iconUrl' : iconUrl,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(80, 255, 255, 255),
                    Color.fromARGB(60, 33, 150, 243),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color.fromARGB(100, 255, 255, 255),
                  width: 1.5,
                ),
              ),
              child: iconUrl.isNotEmpty
                  ? Image.network(
                      iconUrl.startsWith('//') ? 'https:$iconUrl' : iconUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    )
                  : const Icon(Icons.wb_sunny, size: 80, color: Colors.white),
            ),
          const SizedBox(height: 20),
          Text(
            translateCondition(condition, isVietnamese),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(60, 255, 255, 255),
                  Color.fromARGB(40, 33, 150, 243),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: const Color.fromARGB(100, 255, 255, 255),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(20, 0, 0, 0),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(
                  iconUrl.isNotEmpty
                      ? (iconUrl.startsWith('//') ? 'https:$iconUrl' : iconUrl)
                      : 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
                  Icons.water_drop,
                  isVietnamese ? "Độ ẩm" : "Humidity",
                  '$humidity%',
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white38,
                ),
                _buildWeatherDetail(
                  iconUrl.isNotEmpty
                      ? (iconUrl.startsWith('//') ? 'https:$iconUrl' : iconUrl)
                      : 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
                  Icons.air,
                  isVietnamese ? "Sức Gió" : "Wind",
                  '$windKph km/h',
                ),
                if (uv.toString().isNotEmpty) ...[
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color.fromARGB(77, 255, 255, 255),
                  ),
                  _buildWeatherDetail(
                    iconUrl.isNotEmpty
                        ? (iconUrl.startsWith('//')
                            ? 'https:$iconUrl'
                            : iconUrl)
                        : 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
                    Icons.wb_sunny,
                    'UV',
                    '$uv',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(
      String iconUrl, IconData fallbackIcon, String label, String value) {
    String? assetPath;
    if (label.contains("Độ ẩm") || label.contains("Humidity")) {
      assetPath = 'imgs/doam.png';
    } else if (label.contains("Sức Gió") || label.contains("Wind")) {
      assetPath = 'imgs/wind.png';
    } else if (label.contains("UV")) {
      assetPath = 'imgs/uv.png';
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(80, 255, 255, 255),
                Color.fromARGB(60, 33, 150, 243),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromARGB(80, 255, 255, 255),
              width: 1,
            ),
          ),
          child: assetPath != null
              ? Image.asset(
                  assetPath,
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(fallbackIcon, color: Colors.white, size: 20),
                )
              : Icon(fallbackIcon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: const Color.fromARGB(255, 45, 94, 141),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
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
