import 'package:flutter/material.dart';

class PanduanMenyusuiNutrisiPage extends StatelessWidget {
  const PanduanMenyusuiNutrisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Panduan Menyusui & Nutrisi'),
        backgroundColor: const Color(0xFFFFC1CC),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.pink[50],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(28),
              child: Image.asset(
                'assets/icons/cute_baby.png',
                height: 80,
                errorBuilder:
                    (c, o, s) => Icon(
                      Icons.child_friendly,
                      size: 60,
                      color: Colors.pink[200],
                    ),
              ),
            ),
            const SizedBox(height: 28),
            _CuteMenuCard(
              icon: Icons.baby_changing_station,
              title: 'Posisi Menyusui',
              color: Color(0xFFFFB6C1),
              onTap: () => Navigator.pushNamed(context, '/posisi-menyusui'),
            ),
            const SizedBox(height: 18),
            _CuteMenuCard(
              icon: Icons.schedule,
              title: 'Jadwal Pemberian ASI/MPASI',
              color: Color(0xFFFFE082),
              onTap: () => Navigator.pushNamed(context, '/jadwal-asi-mpasi'),
            ),
            const SizedBox(height: 18),
            _CuteMenuCard(
              icon: Icons.local_dining,
              title: 'Tips Nutrisi Ibu Menyusui',
              color: Color(0xFF81C784),
              onTap: () => Navigator.pushNamed(context, '/tips-nutrisi'),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Bunda sehat, bayi bahagia! 💖',
                style: TextStyle(
                  color: Color(0xFFD291BC),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CuteMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  const _CuteMenuCard({
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
        elevation: 2.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(14),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFFB266B2),
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFD291BC)),
            ],
          ),
        ),
      ),
    );
  }
}
