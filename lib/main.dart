import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'weather_service.dart';
import 'current.dart';
import '_7d.dart';
import '_24h.dart';
import 'group_info.dart';
import 'location_service.dart';
import 'location_selector.dart';

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
  final LocationService _locationService = LocationService();
  Map<String, dynamic> _currentWeather = {};
  List<dynamic> _forecast7Days = [];
  LocationModel _currentLocation =
      LocationModel(name: 'Ha Noi', displayName: 'Hà Nội');
  bool _loading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getDeviceLocationAndWeather();
  }

  Future<void> _getDeviceLocationAndWeather() async {
    setState(() {
      _loading = true;
    });
    final deviceLocation = await _locationService.getDeviceLocation();
    if (deviceLocation != null) {
      setState(() {
        _currentLocation = deviceLocation;
      });
      await _loadWeatherData(
          '${deviceLocation.latitude},${deviceLocation.longitude}');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.locale.languageCode == 'vi'
                ? 'Không thể lấy vị trí hiện tại hoặc quyền bị từ chối'
                : 'Unable to get current location or permission denied'),
          ),
        );
      }
      setState(() {
        _currentLocation = LocationModel(
          name: 'Ha Noi',
          displayName: 'Hà Nội',
        );
      });
      await _loadWeatherData('Ha Noi');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadWeatherData(String city) async {
    setState(() {
      _loading = true;
    });

    try {
      final current = await _weatherService.getCurrentWeather(city);
      final forecast7 = await _weatherService.fetch7DayForecast(city);

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

  Future<void> _onLocationChanged(LocationModel location) async {
    setState(() {
      _currentLocation = location;
    });
    await _loadWeatherData(location.name);
  }

  void _showLocationSelector() {
    showDialog(
      context: context,
      builder: (context) => LocationSelectorDialog(
        isVietnamese: widget.locale.languageCode == 'vi',
        onLocationSelected: _onLocationChanged,
      ),
    );
  }

  List<dynamic> _getNext24Hours() {
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
      if (time != null && (time.isAtSameMomentAs(now) || time.isBefore(now))) {
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

    return next24Hours.take(24).toList();
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
                    CurrentWeather(
                      currentWeather: _currentWeather,
                      isVietnamese: isVietnamese,
                      translateCondition: translateCondition,
                      onAddLocationPressed: _showLocationSelector,
                    ),
                    const SizedBox(height: 60),
                    Text(
                      isVietnamese ? 'Dự báo 7 ngày tới' : '7-Day Forecast',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SevenDayForecast(
                      forecast7Days: _forecast7Days,
                      isVietnamese: isVietnamese,
                      translateCondition: translateCondition,
                    ),
                    const SizedBox(height: 60),
                    Text(
                      isVietnamese ? 'Dự báo 24 giờ tới' : '24-Hour Forecast',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    HourlyForecast(
                      next24Hours: _getNext24Hours(),
                      isVietnamese: isVietnamese,
                      translateCondition: translateCondition,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
