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
        color: color.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.deepPurple,
                size: 28,
              ), // warna icon lebih gelap agar kontras
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      Colors.deepPurple, // warna teks lebih gelap agar kontras
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
