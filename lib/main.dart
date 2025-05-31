import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BukuPink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFFB6C1), // Soft pink
          primary: Color(0xFFFFB6C1), // Pink
          secondary: Color(0xFFFFC1CC), // Light pink
          background: Color(0xFFFFF0F5), // Lavender blush
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BukuPink - Ibu Hamil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            MenuCard(
              icon: Icons.favorite,
              title: 'Pemantauan Kehamilan',
              color: Color(0xFFFFB6C1),
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.child_friendly,
              title: 'Persiapan Melahirkan',
              color: Color(0xFFFFC1CC),
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.family_restroom,
              title: 'Pasca Melahirkan',
              color: Color(0xFFB266B2),
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.monitor_heart,
              title: 'Pemantauan Tumbuh Kembang Anak',
              color: Color(0xFF81C784), // hijau pastel
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.local_dining,
              title: 'Panduan Menyusui & Nutrisi',
              color: Color(0xFFFFE082), // kuning pastel
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.self_improvement,
              title: 'Kesehatan Mental Ibu',
              color: Color(0xFF9575CD), // ungu pastel
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.group,
              title: 'Keluarga Berencana',
              color: Color(0xFF4FC3F7), // biru pastel
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0.5,
        shadowColor: color.withOpacity(0.15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.18), width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(14),
                child: Icon(icon, color: color.withOpacity(0.85), size: 30),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
