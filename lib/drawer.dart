import 'package:flutter/material.dart';
import 'group_info.dart';
import 'language_page.dart';

class AppDrawer extends StatelessWidget {
  final Locale locale;
  final void Function(Locale)? onSetLocale;

  const AppDrawer({
    super.key,
    required this.locale,
    this.onSetLocale,
  });

  @override
  Widget build(BuildContext context) {
    final isVietnamese = locale.languageCode == 'vi';
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade600,
              Colors.indigo.shade700,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 220,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade400,
                    Colors.blue.shade700,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(30, 0, 0, 0),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(77, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color.fromARGB(102, 255, 255, 255),
                        width: 2,
                      ),
                    ),
                    child: Image.asset(
                      'imgs/menu.png',
                      width: 45,
                      height: 45,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.wb_sunny,
                          color: Colors.white,
                          size: 45),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isVietnamese ? 'Menu' : 'Menu',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(51, 255, 255, 255),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color.fromARGB(77, 255, 255, 255),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(20, 0, 0, 0),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(77, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.home, color: Colors.white, size: 22),
                ),
                title: Text(
                  isVietnamese ? 'Trang chủ' : 'Home',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(51, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 14),
                ),
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(51, 255, 255, 255),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color.fromARGB(77, 255, 255, 255),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(20, 0, 0, 0),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(77, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'imgs/group.png',
                    width: 22,
                    height: 22,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.info, color: Colors.white, size: 22),
                  ),
                ),
                title: Text(
                  isVietnamese ? 'Thông tin nhóm' : 'Team Info',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(51, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 14),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => InfoPage()),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(51, 255, 255, 255),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color.fromARGB(77, 255, 255, 255),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(20, 0, 0, 0),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(77, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.language, color: Colors.white, size: 22),
                ),
                title: Text(
                  isVietnamese ? 'Ngôn ngữ' : 'Language',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(51, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 14),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LanguagePage(
                        currentLocale: locale,
                        onLocaleChanged: (Locale newLocale) {
                          if (onSetLocale != null) {
                            onSetLocale!(newLocale);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
