import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';
import 'pages_lastperiod.dart';
import 'pages_dashboard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFFFB6C1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFFFFB6C1),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Nama Pengguna',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Periode Terakhir'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/last-period');
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
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
              onTap: () {
                final lastPeriod =
                    Get.find<LastPeriodController>().lastPeriodDate.value;
                if (lastPeriod == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LastPeriodFormPage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PregnancyDashboardPage(),
                    ),
                  );
                }
              },
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
              color: Color(0xFF81C784),
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.local_dining,
              title: 'Panduan Menyusui & Nutrisi',
              color: Color(0xFFFFE082),
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.self_improvement,
              title: 'Kesehatan Mental Ibu',
              color: Color(0xFF9575CD),
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.group,
              title: 'Keluarga Berencana',
              color: Color(0xFF4FC3F7),
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
