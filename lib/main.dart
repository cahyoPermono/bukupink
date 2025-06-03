import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'controllers/controllers.dart';
import 'pages/pages_dashboard.dart';
import 'pages/pages_lastperiod.dart';
import 'pages/pages_home.dart';
import 'pages/pages_login.dart';
import 'pages/pages_signup.dart';
import 'pages/pages_profile.dart';
import 'pages/pages_profile_wizard.dart';
import 'pages/pages_child_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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
          surface: Color(0xFFFFF0F5),
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
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/child-list', page: () => const ChildListPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/last-period', page: () => LastPeriodFormPage()),
        GetPage(name: '/dashboard', page: () => PregnancyDashboardPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/profile-wizard', page: () => const ProfileWizardPage()),
      ],
    );
  }
}
