import 'package:flutter/material.dart';

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
