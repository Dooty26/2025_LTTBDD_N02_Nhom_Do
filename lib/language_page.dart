import 'package:flutter/material.dart';
import 'drawer.dart';

class LanguagePage extends StatefulWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const LanguagePage({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.currentLocale;
  }

  void _changeLanguage(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
    });
    widget.onLocaleChanged(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _currentLocale.languageCode == 'vi';
    return Scaffold(
      drawer: AppDrawer(
        locale: _currentLocale,
        onSetLocale: _changeLanguage,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade600,
              Colors.indigo.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(77, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: const Icon(Icons.menu, color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          isVietnamese ? 'Chọn ngôn ngữ' : 'Select Language',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(61, 255, 255, 255),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color.fromARGB(97, 255, 255, 255),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(25, 0, 0, 0),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            _changeLanguage(const Locale('vi'));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isVietnamese
                                ? Colors.orange.shade600
                                : const Color.fromARGB(77, 255, 255, 255),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                color: isVietnamese
                                    ? Colors.orange.shade600
                                    : const Color.fromARGB(128, 255, 255, 255),
                                width: 2,
                              ),
                            ),
                            elevation: isVietnamese ? 8 : 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isVietnamese
                                      ? const Color.fromARGB(51, 255, 255, 255)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '🇻🇳',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Tiếng Việt',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isVietnamese
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            _changeLanguage(const Locale('en'));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isVietnamese
                                ? Colors.orange.shade600
                                : const Color.fromARGB(77, 255, 255, 255),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                color: !isVietnamese
                                    ? Colors.orange.shade600
                                    : const Color.fromARGB(128, 255, 255, 255),
                                width: 2,
                              ),
                            ),
                            elevation: !isVietnamese ? 8 : 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: !isVietnamese
                                      ? const Color.fromARGB(51, 255, 255, 255)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '🇺🇸',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'English',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: !isVietnamese
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
