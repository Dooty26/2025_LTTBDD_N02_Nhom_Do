import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'weather_service.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('vi');

  void _changeLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'vi'
          ? const Locale('en')
          : const Locale('vi');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dự Báo Thời Tiết',
      locale: _locale,
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomePage(
        onLanguageChange: _changeLanguage,
        locale: _locale,
      ),
    );
  }
}

String translateCondition(String condition, bool isVietnamese) {
  if (!isVietnamese) return condition;
  switch (condition.toLowerCase().trim()) {
    case 'overcast':
      return 'U ám';
    case 'patchy rain nearby':
      return 'Mưa rải rác';
    case 'sunny':
      return 'Nắng';
    case 'cloudy':
      return 'Nhiều mây';
    case 'light rain':
      return 'Mưa nhẹ';
    case 'moderate rain':
      return 'Mưa vừa';
    case 'partly cloudy':
      return 'Trời có mây';
    default:
      return condition;
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onLanguageChange;
  final Locale locale;

  const HomePage({
    super.key,
    required this.onLanguageChange,
    required this.locale,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic> _currentWeather = {};
  List<dynamic> _forecast7Days = [];
  bool _loading = true;
  final String _city = 'Hanoi';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllWeatherData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllWeatherData() async {
    try {
      final current = await _weatherService.getCurrentWeather(_city);
      final forecast7 = await _weatherService.fetch7DayForecast(_city);

      setState(() {
        _currentWeather = current;
        _forecast7Days = forecast7;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = widget.locale.languageCode == 'vi';
    return Scaffold(
      appBar: AppBar(
        title: Text(isVietnamese ? 'Dự Báo Thời Tiết' : 'Weather Forecast'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: widget.onLanguageChange,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text(isVietnamese ? 'Menu' : 'Menu',
                  style: const TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(isVietnamese ? 'Thông tin nhóm' : 'Team Info'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InfoPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCurrentWeather(isVietnamese),
                    const SizedBox(height: 60),
                    Text(
                      isVietnamese ? 'Dự báo 7 ngày tới' : '7-Day Forecast',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 240,
                      child: ScrollConfiguration(
                        behavior:
                            const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _forecast7Days.length,
                          itemBuilder: (context, index) {
                            final item = _forecast7Days[index];
                            return Container(
                              width: 180,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: _buildDayForecast(item, isVietnamese),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Text(
                      isVietnamese ? 'Dự báo 24 giờ tới' : '24-Hour Forecast',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 240,
                      child: Builder(
                        builder: (context) {
                          final now = DateTime.now();

                          List<dynamic> allHours = [];
                          if (_forecast7Days.isNotEmpty) {
                            allHours.addAll(_forecast7Days[0]['hour']);
                            if (_forecast7Days.length > 1) {
                              allHours.addAll(_forecast7Days[1]['hour']);
                            }
                          }

                          dynamic nowHour;
                          for (var item in allHours) {
                            final timeStr = item['time'] as String? ?? '';
                            final time = DateTime.tryParse(timeStr);
                            if (time != null &&
                                (time.isAtSameMomentAs(now) ||
                                    time.isBefore(now))) {
                              nowHour = item;
                            } else if (time != null && time.isAfter(now)) {
                              break;
                            }
                          }

                          final filteredHours = allHours.where((item) {
                            final timeStr = item['time'] as String? ?? '';
                            final time = DateTime.tryParse(timeStr);
                            return time != null && time.isAfter(now);
                          }).toList();

                          List<dynamic> next24Hours = [];
                          if (nowHour != null) {
                            next24Hours.add(nowHour);
                          }
                          next24Hours.addAll(filteredHours);

                          next24Hours = next24Hours.take(24).toList();

                          return ScrollConfiguration(
                            behavior: const ScrollBehavior()
                                .copyWith(overscroll: false),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: next24Hours.length,
                              itemBuilder: (context, index) {
                                final item = next24Hours[index];
                                return Container(
                                  width: 160,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: _buildHourForecast(item, isVietnamese),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCurrentWeather(bool isVietnamese) {
    final temp = _currentWeather['temp_c'] ?? '';
    final condition = _currentWeather['condition']?['text'] ?? '';
    final iconUrl = _currentWeather['condition']?['icon'] ?? '';
    final humidity = _currentWeather['humidity'] ?? '';
    final windKph = _currentWeather['wind_kph'] ?? '';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isVietnamese ? 'Thời tiết hiện tại' : 'Current Weather',
              style: const TextStyle(fontSize: 35)),
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

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isVietnamese = Localizations.localeOf(context).languageCode == 'vi';
    return Scaffold(
      appBar: AppBar(
        title: Text(isVietnamese ? 'Thông tin nhóm' : 'Team Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dam Quang Do - 23010046',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(isVietnamese ? 'Trang chủ' : 'Home'),
            ),
          ],
        ),
      ),
    );
  }
}
