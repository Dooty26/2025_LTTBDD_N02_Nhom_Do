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
      height: 260,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: forecast7Days.length,
          itemBuilder: (context, index) {
            final item = forecast7Days[index];
            return Container(
              width: 160,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildDayForecast(item, isVietnamese, index == 0),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayForecast(dynamic item, bool isVietnamese, bool isToday) {
    final date = item['date'] ?? '';
    final day = item['day'] ?? {};
    final maxTemp = day['maxtemp_c'] ?? '';
    final minTemp = day['mintemp_c'] ?? '';
    final humidity = day['avghumidity']?.toString() ?? '';
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

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(85, 255, 255, 255),
            Color.fromARGB(65, 255, 255, 255),
            Color.fromARGB(55, 33, 150, 243),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color.fromARGB(110, 255, 255, 255),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(35, 0, 0, 0),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color.fromARGB(40, 255, 255, 255),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                topText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              if (bottomText.isNotEmpty)
                Text(
                  bottomText,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color.fromARGB(255, 204, 204, 204),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(90, 255, 255, 255),
                  Color.fromARGB(70, 33, 150, 243),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color.fromARGB(80, 255, 255, 255),
                width: 1,
              ),
            ),
            child: iconUrl.isNotEmpty
                ? Image.network(
                    iconUrl.startsWith('//') ? 'https:$iconUrl' : iconUrl,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.wb_cloudy,
                        size: 40,
                        color: Colors.white),
                  )
                : const Icon(Icons.wb_cloudy, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            translateCondition(condition, isVietnamese),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(80, 255, 255, 255),
                  Color.fromARGB(60, 33, 150, 243),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color.fromARGB(90, 255, 255, 255),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(25, 0, 0, 0),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$minTemp°',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(220, 231, 227, 227),
                      ),
                    ),
                    Text(
                      '/$maxTemp°',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                if (humidity.isNotEmpty && humidity != 'null') ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'imgs/doam.png',
                        width: 12,
                        height: 12,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.water_drop,
                                size: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isVietnamese ? '$humidity%' : '$humidity%',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
