import 'package:flutter/material.dart';
import 'pages_pregnancy_list.dart';
import 'pages_persiapan_kelahiran.dart';
import 'pages_pasca_melahirkan.dart';
import '../services/services_user.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC1CC),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFB6C1), Color(0xFFFFE0F0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FutureBuilder(
                future: UserProfileService.getProfile(),
                builder: (context, snapshot) {
                  String displayName = 'Nama Pengguna';
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    displayName = 'Memuat...';
                  } else if (snapshot.hasData && snapshot.data != null) {
                    displayName = snapshot.data?.name ?? 'Nama Pengguna';
                  }
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/icons/cute_girl.png',
                              height: 48,
                              width: 48,
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (c, o, s) => Icon(
                                    Icons.person,
                                    size: 44,
                                    color: Color(0xFFFFB6C1),
                                  ),
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            displayName,
                            style: TextStyle(
                              color: Color(0xFFB266B2),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Nunito',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(height: 2, color: Colors.transparent),
            SizedBox(height: 0),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
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
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 0.85,
          children: [
            MenuCard(
              icon: Icons.favorite,
              title: 'Pemantauan Kehamilan',
              color: Color(0xFFFFB6C1),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PregnancyListPage()),
                );
              },
            ),
            MenuCard(
              icon: Icons.child_friendly,
              title: 'Persiapan Melahirkan',
              color: Color(0xFFFFC1CC),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PersiapanKelahiranPage(),
                  ),
                );
              },
            ),
            MenuCard(
              icon: Icons.family_restroom,
              title: 'Pasca Melahirkan',
              color: Color(0xFFB266B2),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PascaMelahirkanPage(),
                  ),
                );
              },
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 2.5,
          shadowColor: color.withOpacity(0.18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: color.withOpacity(0.22), width: 1.5),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 10,
            ), // padding vertikal dikurangi
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.16),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.12),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12), // padding icon dikurangi
                  child: Icon(
                    icon,
                    color: color.withOpacity(0.95),
                    size: 32,
                  ), // icon lebih kecil
                ),
                const SizedBox(height: 10), // jarak antar elemen dikurangi
                Text(
                  title,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3, // maxLines jadi 3
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB266B2),
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
