import 'package:flutter/material.dart';

class EdukasiKbPage extends StatelessWidget {
  const EdukasiKbPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_EdukasiKB> edukasi = [
      _EdukasiKB(
        icon: Icons.info_outline,
        color: Color(0xFFFFB6C1),
        title: 'Apa itu KB Pasca Salin?',
        desc:
            'KB pasca salin adalah upaya mencegah kehamilan setelah melahirkan, agar ibu pulih dan anak mendapat ASI eksklusif.',
      ),
      _EdukasiKB(
        icon: Icons.access_time,
        color: Color(0xFF9575CD),
        title: 'Kapan Mulai KB?',
        desc:
            'KB dapat dimulai segera setelah melahirkan, terutama jika ibu tidak menyusui. Jika menyusui, konsultasikan waktu terbaik ke tenaga kesehatan.',
      ),
      _EdukasiKB(
        icon: Icons.child_care,
        color: Color(0xFF81C784),
        title: 'Manfaat KB Pasca Salin',
        desc:
            '• Mencegah kehamilan terlalu dekat\n• Memberi waktu pemulihan untuk ibu\n• Mendukung pemberian ASI eksklusif\n• Menjaga kesehatan ibu & anak',
      ),
      _EdukasiKB(
        icon: Icons.warning_amber_rounded,
        color: Color(0xFFFFE082),
        title: 'Hal yang Perlu Diperhatikan',
        desc:
            '• Pilih metode KB yang sesuai kondisi ibu\n• Konsultasikan ke bidan/dokter\n• Pantau efek samping dan segera periksa jika ada keluhan',
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Edukasi KB Pasca Salin'),
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
            Expanded(
              child: ListView.separated(
                itemCount: edukasi.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final e = edukasi[i];
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
                              color: e.color.withValues(alpha: 0.16),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Icon(e.icon, color: e.color, size: 32),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color(0xFFB266B2),
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  e.desc,
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
                'KB pasca salin bantu ibu & anak lebih sehat, keluarga lebih bahagia! 💙',
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

class _EdukasiKB {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  _EdukasiKB({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });
}
