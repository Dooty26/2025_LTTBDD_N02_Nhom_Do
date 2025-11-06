import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final List<dynamic> next24Hours;
  final bool isVietnamese;
  final String Function(String, bool) translateCondition;

  const HourlyForecast({
    super.key,
    required this.next24Hours,
    required this.isVietnamese,
    required this.translateCondition,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: next24Hours.length,
          itemBuilder: (context, index) {
            final item = next24Hours[index];
            return Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildHourForecast(item, isVietnamese, index == 0),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHourForecast(dynamic item, bool isVietnamese, bool isNow) {
    final time = item['time']?.substring(11, 16) ?? '';
    final temp = item['temp_c'] ?? '';
    final condition = item['condition']?['text'] ?? '';
    final iconUrl = item['condition']?['icon'] ?? '';
    final humidity = item['humidity'] ?? '';

    String displayTime = time;
    final now = DateTime.now();
    final itemTime = DateTime.tryParse(item['time'] ?? '');
    if (itemTime != null &&
        itemTime.hour == now.hour &&
        itemTime.day == now.day &&
        itemTime.month == now.month &&
        itemTime.year == now.year) {
      displayTime = isVietnamese ? 'Hiện tại' : 'Now';
      isNow = true;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(85, 255, 255, 255),
            Color.fromARGB(65, 255, 255, 255),
            Color.fromARGB(55, 33, 150, 243),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color.fromARGB(110, 255, 255, 255),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(35, 0, 0, 0),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: const Color.fromARGB(40, 255, 255, 255),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            displayTime,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(90, 255, 255, 255),
                  Color.fromARGB(70, 33, 150, 243),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(80, 255, 255, 255),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(25, 0, 0, 0),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: iconUrl.isNotEmpty
                ? Image.network(
                    iconUrl.startsWith('//') ? 'https:$iconUrl' : iconUrl,
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.wb_cloudy,
                        size: 32,
                        color: Colors.white),
                  )
                : const Icon(Icons.wb_cloudy, size: 32, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            '$temp°',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'imgs/doam.png',
                width: 10,
                height: 10,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.water_drop, size: 10, color: Colors.white),
              ),
              const SizedBox(width: 5),
              Text(
                (humidity.toString().isNotEmpty &&
                        humidity.toString() != 'null')
                    ? (isVietnamese ? '$humidity%' : '$humidity%')
                    : (isVietnamese ? '--%' : '--%'),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            translateCondition(condition, isVietnamese),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
