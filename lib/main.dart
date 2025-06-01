import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';
import 'pages_dashboard.dart';
import 'pages_lastperiod.dart';
import 'pages_home.dart';
import 'pages_login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LastPeriodController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BukuPink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFFB6C1),
          primary: Color(0xFFFFB6C1),
          secondary: Color(0xFFFFC1CC),
          background: Color(0xFFFFF0F5),
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFFFFF0F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFB6C1),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFB6C1),
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Color(0xFFB266B2),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/last-period', page: () => LastPeriodFormPage()),
        GetPage(name: '/dashboard', page: () => PregnancyDashboardPage()),
      ],
    );
  }
}
