import 'package:flutter/material.dart';
import '../services/services_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await UserProfileService.getProfile();
    setState(() {
      _profile = profile;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil'), centerTitle: true),
        body: const Center(child: Text('Data profil belum tersedia.')),
      );
    }
    final name = _profile!.name;
    final age = _profile!.age;
    final height = _profile!.height;
    final weight = _profile!.weight;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        backgroundColor: Color(0xFFFFB6C1),
        elevation: 0,
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
                  String displayName = name;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    displayName = 'Memuat...';
                  } else if (snapshot.hasData && snapshot.data != null) {
                    displayName = snapshot.data?.name ?? name;
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
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
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
      body: Stack(
        children: [
          // Cute background accent
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFFFFB6C1).withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 36,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFB6C1), Color(0xFFFFC1CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFFB6C1).withValues(alpha: 0.18),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 54,
                          color: Color(0xFFFFB6C1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB266B2),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Profil Pengguna',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFB266B2).withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _cuteProfileRow(
                      Icons.cake,
                      'Usia',
                      '$age tahun',
                      Color(0xFFFFB6C1),
                    ),
                    _cuteProfileRow(
                      Icons.height,
                      'Tinggi Badan',
                      '${height.toStringAsFixed(1)} cm',
                      Color(0xFF81C784),
                    ),
                    _cuteProfileRow(
                      Icons.monitor_weight,
                      'Berat Badan',
                      '${weight.toStringAsFixed(1)} kg',
                      Color(0xFFFFE082),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cuteProfileRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 18),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFFB266B2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
