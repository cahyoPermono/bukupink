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
import 'services/services.dart';
import 'pages/pages_panduan_menyusui_nutrisi.dart';
import 'pages/pages_posisi_menyusui.dart';
import 'pages/pages_jadwal_asi_mpasi.dart';
import 'pages/pages_tips_nutrisi.dart';
import 'pages/pages_kesehatan_mental_ibu.dart';
import 'pages/pages_screening_gejala.dart';
import 'pages/pages_konseling_rujukan.dart';
import 'pages/pages_keluarga_berencana.dart';
import 'pages/pages_edukasi_kb.dart';
import 'pages/pages_metode_kb.dart';

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
    return FutureBuilder(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        final loggedIn = snapshot.data as bool;
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
          initialRoute: loggedIn ? '/home' : '/login',
          getPages: [
            GetPage(name: '/login', page: () => LoginPage()),
            GetPage(name: '/signup', page: () => SignupPage()),
            GetPage(name: '/home', page: () => HomePage()),
            GetPage(name: '/child-list', page: () => const ChildListPage()),
            GetPage(name: '/last-period', page: () => LastPeriodFormPage()),
            GetPage(name: '/dashboard', page: () => PregnancyDashboardPage()),
            GetPage(name: '/profile', page: () => const ProfilePage()),
            GetPage(
              name: '/profile-wizard',
              page: () => const ProfileWizardPage(),
            ),
            GetPage(
              name: '/panduan-menyusui-nutrisi',
              page: () => PanduanMenyusuiNutrisiPage(),
            ),
            GetPage(name: '/posisi-menyusui', page: () => PosisiMenyusuiPage()),
            GetPage(
              name: '/jadwal-asi-mpasi',
              page: () => JadwalAsiMpasiPage(),
            ),
            GetPage(name: '/tips-nutrisi', page: () => TipsNutrisiPage()),
            GetPage(
              name: '/kesehatan-mental-ibu',
              page: () => KesehatanMentalIbuPage(),
            ),
            GetPage(
              name: '/screening-gejala',
              page: () => ScreeningGejalaPage(),
            ),
            GetPage(
              name: '/konseling-rujukan',
              page: () => KonselingRujukanPage(),
            ),
            GetPage(
              name: '/keluarga-berencana',
              page: () => KeluargaBerencanaPage(),
            ),
            GetPage(name: '/edukasi-kb', page: () => EdukasiKbPage()),
            GetPage(name: '/metode-kb', page: () => MetodeKbPage()),
          ],
        );
      },
    );
  }
}
