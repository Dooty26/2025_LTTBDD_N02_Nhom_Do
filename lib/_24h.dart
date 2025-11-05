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
      height: 240,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: next24Hours.length,
          itemBuilder: (context, index) {
            final item = next24Hours[index];
            return Container(
              width: 160,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildHourForecast(item, isVietnamese),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHourForecast(dynamic item, bool isVietnamese) {
    final time = item['time']?.substring(11, 16) ?? '';
    final temp = item['temp_c'] ?? '';
    final condition = item['condition']?['text'] ?? '';
    final iconUrl = item['condition']?['icon'] ?? '';

    String displayTime = time;
    final now = DateTime.now();
    final itemTime = DateTime.tryParse(item['time'] ?? '');
    if (itemTime != null &&
        itemTime.hour == now.hour &&
        itemTime.day == now.day &&
        itemTime.month == now.month &&
        itemTime.year == now.year) {
      displayTime = isVietnamese ? 'Hiện tại' : 'Now';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconUrl.isNotEmpty)
            Image.network(
              iconUrl.startsWith('//') ? 'https:$iconUrl' : iconUrl,
              width: 64,
              height: 64,
            )
          else
            Icon(Icons.access_time, size: 64, color: Colors.green),
          const SizedBox(height: 10),
          Text(displayTime,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(translateCondition(condition, isVietnamese),
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 6),
          Text('${isVietnamese ? "Nhiệt độ" : "Temp"}: $temp°C',
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
