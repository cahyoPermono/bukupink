import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';

class PregnancyDashboardPage extends StatelessWidget {
  const PregnancyDashboardPage({super.key});

  int calculatePregnancyWeeks(DateTime lastPeriod) {
    final now = DateTime.now();
    final diff = now.difference(lastPeriod);
    return (diff.inDays / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    final lastPeriod = Get.find<LastPeriodController>().lastPeriodDate.value;
    final weeks = lastPeriod != null ? calculatePregnancyWeeks(lastPeriod) : 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Kehamilan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Umur Kehamilan',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '$weeks minggu',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              'Tanggal Haid Terakhir: ${lastPeriod != null ? "${lastPeriod.day}-${lastPeriod.month}-${lastPeriod.year}" : "-"}',
            ),
          ],
        ),
      ),
    );
  }
}
