import 'package:flutter/material.dart';

class KeluargaBerencanaPage extends StatelessWidget {
  const KeluargaBerencanaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Keluarga Berencana'),
        backgroundColor: const Color(0xFF4FC3F7),
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
                color: Colors.blue[50],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(28),
              child: Image.asset(
                'assets/icons/family_planning.png',
                height: 80,
                errorBuilder:
                    (c, o, s) => Icon(
                      Icons.family_restroom,
                      size: 60,
                      color: Colors.blue[200],
                    ),
              ),
            ),
            const SizedBox(height: 28),
            _CuteMenuCard(
              icon: Icons.school,
              title: 'Edukasi KB Pasca Salin',
              color: Color(0xFFFFB6C1),
              onTap: () => Navigator.pushNamed(context, '/edukasi-kb'),
            ),
            const SizedBox(height: 18),
            _CuteMenuCard(
              icon: Icons.check_circle_outline,
              title: 'Metode yang Dipilih',
              color: Color(0xFF81C784),
              onTap: () => Navigator.pushNamed(context, '/metode-kb'),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Rencanakan keluarga, wujudkan masa depan cerah! 💙',
                style: TextStyle(
                  color: Color(0xFF4FC3F7),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  fontFamily: 'Nunito',
                ),
                textAlign: TextAlign.center,
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
