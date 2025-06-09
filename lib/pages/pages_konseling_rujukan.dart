import 'package:flutter/material.dart';

class KonselingRujukanPage extends StatelessWidget {
  const KonselingRujukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_KonselingInfo> konseling = [
      _KonselingInfo(
        icon: Icons.phone,
        color: Color(0xFF9575CD),
        title: 'Layanan Konseling Gratis',
        desc:
            '• Halo Kemenkes: 1500-567\n• Sehat Jiwa: 119 ext 8\n• Puskesmas/Bidan terdekat',
      ),
      _KonselingInfo(
        icon: Icons.chat_bubble_outline,
        color: Color(0xFF4FC3F7),
        title: 'Konseling Online',
        desc:
            '• SehatPedia (Aplikasi Kemenkes)\n• Konseling psikolog via Halodoc, Alodokter, dll.',
      ),
      _KonselingInfo(
        icon: Icons.local_hospital,
        color: Color(0xFFFFB6C1),
        title: 'Rujukan Fasilitas Kesehatan',
        desc:
            '• RSUD, RS Ibu & Anak\n• Klinik Psikologi\n• Konsultasi ke dokter spesialis jiwa',
      ),
      _KonselingInfo(
        icon: Icons.family_restroom,
        color: Color(0xFFFFE082),
        title: 'Dukungan Keluarga',
        desc:
            '• Ceritakan perasaan ke pasangan/keluarga\n• Jangan ragu minta bantuan\n• Tidak sendiri, banyak ibu mengalami hal serupa',
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Konseling / Rujukan'),
        backgroundColor: const Color(0xFF9575CD),
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
                color: Colors.purple[50],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(28),
              child: Image.asset(
                'assets/icons/mental_health.png',
                height: 80,
                errorBuilder:
                    (c, o, s) => Icon(
                      Icons.support_agent,
                      size: 60,
                      color: Colors.purple[200],
                    ),
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: ListView.separated(
                itemCount: konseling.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final k = konseling[i];
                  return Card(
                    color: Colors.white,
                    elevation: 2.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: k.color.withValues(alpha: 0.16),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Icon(k.icon, color: k.color, size: 32),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  k.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color(0xFFB266B2),
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  k.desc,
                                  style: const TextStyle(
                                    color: Color(0xFFAD1457),
                                    fontSize: 15.5,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                'Jangan ragu mencari bantuan profesional atau bercerita ke orang terdekat. Ibu tidak sendiri! 💜',
                style: TextStyle(
                  color: Color(0xFF9575CD),
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

class _KonselingInfo {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  _KonselingInfo({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });
}
