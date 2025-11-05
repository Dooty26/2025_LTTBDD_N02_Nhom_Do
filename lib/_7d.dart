import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SevenDayForecast extends StatelessWidget {
  final List<dynamic> forecast7Days;
  final bool isVietnamese;
  final String Function(String, bool) translateCondition;

  const SevenDayForecast({
    super.key,
    required this.forecast7Days,
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
          itemCount: forecast7Days.length,
          itemBuilder: (context, index) {
            final item = forecast7Days[index];
            return Container(
              width: 180,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildDayForecast(item, isVietnamese),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayForecast(dynamic item, bool isVietnamese) {
    final date = item['date'] ?? '';
    final day = item['day'] ?? {};
    final maxTemp = day['maxtemp_c'] ?? '';
    final minTemp = day['mintemp_c'] ?? '';
    final condition = day['condition']?['text'] ?? '';
    final iconUrl = day['condition']?['icon'] ?? '';

    String topText = '';
    String bottomText = '';
    try {
      final dateTime = DateTime.parse(date);
      final dayMonth = DateFormat('dd/MM').format(dateTime);
      final weekday =
          DateFormat.EEEE(isVietnamese ? 'vi' : 'en').format(dateTime);

      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));

      if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day) {
        topText = isVietnamese ? 'Hôm nay' : 'Today';
        bottomText = dayMonth;
      } else if (dateTime.year == tomorrow.year &&
          dateTime.month == tomorrow.month &&
          dateTime.day == tomorrow.day) {
        topText = isVietnamese ? 'Ngày mai' : 'Tomorrow';
        bottomText = dayMonth;
      } else {
        topText = weekday;
        bottomText = dayMonth;
      }
    } catch (e) {
      topText = date;
      bottomText = '';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            topText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (bottomText.isNotEmpty)
            Text(
              bottomText,
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 10),
          if (iconUrl.isNotEmpty)
            Image.network(
              iconUrl.startsWith('//') ? 'https:$iconUrl' : iconUrl,
              width: 64,
              height: 64,
            )
          else
            Icon(Icons.calendar_today, size: 64, color: Colors.blue),
          Text(
            translateCondition(condition, isVietnamese),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            '${isVietnamese ? "Nhiệt độ" : "Temp"}: $minTemp°/$maxTemp°',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
