import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: const [
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

class HomePage extends StatelessWidget {
  final VoidCallback onLanguageChange;
  final Locale locale;

  const HomePage({
    super.key,
    required this.onLanguageChange,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final isVietnamese = locale.languageCode == 'vi';
    return Scaffold(
      appBar: AppBar(
        title: Text(isVietnamese
            ? 'Dự Báo Thời Tiết'
            : 'Weather Forecast'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: onLanguageChange,
            tooltip: isVietnamese
                ? 'Chuyển sang tiếng Anh'
                : 'Switch to Vietnamese',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                isVietnamese ? 'Menu' : 'Menu',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(isVietnamese
                  ? 'Thông tin nhóm'
                  : 'Team Info'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const InfoPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud,
                  size: 80, color: Colors.blueAccent),
              const SizedBox(height: 16),
              Text(
                isVietnamese
                    ? 'Nhiệt độ hiện tại: 28°C'
                    : 'Current temperature: 28°C',
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                isVietnamese
                    ? 'Trời quang đãng'
                    : 'Clear sky',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
            ]),
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isVietnamese =
        Localizations.localeOf(context).languageCode ==
            'vi';
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isVietnamese ? 'Thông tin nhóm' : 'Team Info'),
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
              child:
                  Text(isVietnamese ? 'Trang chủ' : 'Home'),
            ),
          ],
        ),
      ),
    );
  }
}
