import 'package:flutter/material.dart';

class JadwalAsiMpasiPage extends StatelessWidget {
  const JadwalAsiMpasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_JadwalAsiMpasi> jadwal = [
      _JadwalAsiMpasi(
        usia: '0-6 Bulan',
        icon: Icons.child_friendly,
        color: Color(0xFFFFB6C1),
        jadwal: [
          'Hanya ASI eksklusif, tanpa tambahan makanan/minuman lain.',
          'Frekuensi: 8-12 kali/hari (sesuai permintaan bayi).',
          'Tanda cukup: bayi buang air kecil 6-8x/hari, berat naik.',
        ],
      ),
      _JadwalAsiMpasi(
        usia: '6-8 Bulan',
        icon: Icons.restaurant,
        color: Color(0xFFFFE082),
        jadwal: [
          'ASI tetap diberikan.',
          'Mulai MPASI: 2-3x makan utama + 1-2x snack.',
          'Tekstur: lumat/saring, porsi kecil, perkenalkan 1 jenis baru tiap 3 hari.',
        ],
      ),
      _JadwalAsiMpasi(
        usia: '9-11 Bulan',
        icon: Icons.rice_bowl,
        color: Color(0xFF81C784),
        jadwal: [
          'ASI tetap diberikan.',
          'MPASI: 3-4x makan utama + 1-2x snack.',
          'Tekstur: lebih kasar/cincang, porsi bertambah.',
        ],
      ),
      _JadwalAsiMpasi(
        usia: '12-24 Bulan',
        icon: Icons.emoji_food_beverage,
        color: Color(0xFF9575CD),
        jadwal: [
          'ASI tetap diberikan hingga 2 tahun.',
          'MPASI: 3-4x makan utama + 1-2x snack.',
          'Tekstur: makanan keluarga, porsi sesuai usia.',
        ],
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Jadwal Pemberian ASI/MPASI'),
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
                    color: Colors.pinkAccent.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(28),
              child: Image.asset(
                'assets/icons/baby_food.png',
                height: 80,
                errorBuilder:
                    (c, o, s) => Icon(
                      Icons.restaurant,
                      size: 60,
                      color: Colors.pink[200],
                    ),
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: ListView.separated(
                itemCount: jadwal.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final j = jadwal[i];
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
                              color: j.color.withOpacity(0.16),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Icon(j.icon, color: j.color, size: 32),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  j.usia,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color(0xFFB266B2),
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...j.jadwal.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '• ',
                                          style: TextStyle(
                                            color: Color(0xFFB266B2),
                                            fontSize: 15,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                              color: Color(0xFFAD1457),
                                              fontSize: 15.5,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                'Setiap anak unik, jadwal bisa menyesuaikan kebutuhan ya, Bunda! 💕',
                style: TextStyle(
                  color: Color(0xFFD291BC),
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

class _JadwalAsiMpasi {
  final String usia;
  final IconData icon;
  final Color color;
  final List<String> jadwal;
  _JadwalAsiMpasi({
    required this.usia,
    required this.icon,
    required this.color,
    required this.jadwal,
  });
}
