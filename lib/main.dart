import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'weather_service.dart';
import 'current.dart';
import '_7d.dart';
import '_24h.dart';
import 'location_service.dart';
import 'location_selector.dart';
import 'drawer.dart';

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

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

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
        onSetLocale: _setLocale,
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
    case 'light rain shower':
      return 'Mưa rào nhẹ';
    case 'patchy light rain':
      return 'Mưa nhẹ rải rác';
    case 'fog':
      return 'Sương mù';
    case 'clear':
      return 'Trời quang đãng';
    default:
      return condition;
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onLanguageChange;
  final void Function(Locale) onSetLocale;
  final Locale locale;

  const HomePage({
    super.key,
    required this.onLanguageChange,
    required this.onSetLocale,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade500,
              Colors.blue.shade700,
              Colors.blue.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(77, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(25, 0, 0, 0),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                              icon: const Icon(Icons.menu,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(51, 255, 255, 255),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(102, 255, 255, 255),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                isVietnamese
                                    ? 'Dự Báo Thời Tiết'
                                    : 'Weather Forecast',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  _loading
                      ? Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.blue.shade300,
                                Colors.blue.shade500,
                                Colors.blue.shade700,
                                Colors.blue.shade900,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  isVietnamese ? 'Đang tải' : 'loading',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CurrentWeather(
                                currentWeather: _currentWeather,
                                isVietnamese: isVietnamese,
                                translateCondition: translateCondition,
                                onAddLocationPressed: _showLocationSelector,
                              ),
                              const SizedBox(height: 30),
                              Container(
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(80, 255, 255, 255),
                                      Color.fromARGB(60, 255, 255, 255),
                                      Color.fromARGB(70, 110, 226, 245),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        120, 255, 255, 255),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(35, 0, 0, 0),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                          40, 255, 255, 255),
                                      blurRadius: 8,
                                      offset: const Offset(0, -2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(120, 110, 226, 245),
                                            Color.fromARGB(100, 106, 130, 251),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              90, 255, 255, 255),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/imgs/7&24.png',
                                            width: 26,
                                            height: 26,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                const Icon(Icons.calendar_today,
                                                    color: Colors.white,
                                                    size: 26),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            isVietnamese
                                                ? 'Dự báo 7 ngày tới'
                                                : '7-Day Forecast',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SevenDayForecast(
                                      forecast7Days: _forecast7Days,
                                      isVietnamese: isVietnamese,
                                      translateCondition: translateCondition,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25),
                              Container(
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(80, 255, 255, 255),
                                      Color.fromARGB(60, 255, 255, 255),
                                      Color.fromARGB(70, 252, 70, 107),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        120, 255, 255, 255),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(35, 0, 0, 0),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                          40, 255, 255, 255),
                                      blurRadius: 8,
                                      offset: const Offset(0, -2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(120, 252, 70, 107),
                                            Color.fromARGB(100, 63, 94, 251),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              90, 255, 255, 255),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/imgs/7&24.png',
                                            width: 26,
                                            height: 26,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                const Icon(Icons.access_time,
                                                    color: Colors.white,
                                                    size: 26),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            isVietnamese
                                                ? 'Dự báo 24 giờ tới'
                                                : '24-Hour Forecast',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    HourlyForecast(
                                      next24Hours: _getNext24Hours(),
                                      isVietnamese: isVietnamese,
                                      translateCondition: translateCondition,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(
        locale: widget.locale,
        onSetLocale: widget.onSetLocale,
      ),
    );
  }
}
