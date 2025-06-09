import 'package:flutter/material.dart';

class MetodeKbPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<_MetodeKB> metode = [
      _MetodeKB(
        icon: Icons.spa,
        color: Color(0xFF81C784),
        title: 'Metode Amenore Laktasi (MAL)',
        desc:
            'KB alami dengan menyusui eksklusif, efektif 6 bulan pertama jika belum haid dan bayi hanya ASI.',
      ),
      _MetodeKB(
        icon: Icons.medication,
        color: Color(0xFFFFB6C1),
        title: 'Pil KB',
        desc:
            'Pil KB khusus menyusui (progesteron saja) aman untuk ibu menyusui.',
      ),
      _MetodeKB(
        icon: Icons.invert_colors,
        color: Color(0xFF9575CD),
        title: 'Suntik KB',
        desc:
            'Suntik KB 3 bulan (progesteron) dapat digunakan setelah 6 minggu pasca melahirkan.',
      ),
      _MetodeKB(
        icon: Icons.device_hub,
        color: Color(0xFF4FC3F7),
        title: 'Implan',
        desc:
            'Batang kecil di lengan, efektif hingga 3 tahun, aman untuk ibu menyusui.',
      ),
      _MetodeKB(
        icon: Icons.loop,
        color: Color(0xFFFFE082),
        title: 'IUD (Spiral)',
        desc:
            'Alat dalam rahim, efektif hingga 5-10 tahun, bisa dipasang segera setelah melahirkan.',
      ),
      _MetodeKB(
        icon: Icons.male,
        color: Color(0xFFF48FB1),
        title: 'Kondom',
        desc:
            'Mudah digunakan, tanpa efek samping hormonal, bisa langsung digunakan kapan saja.',
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Metode yang Dipilih'),
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
                    color: Colors.blueAccent.withOpacity(0.08),
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
                      Icons.check_circle_outline,
                      size: 60,
                      color: Colors.blue[200],
                    ),
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: ListView.separated(
                itemCount: metode.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final m = metode[i];
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
                              color: m.color.withOpacity(0.16),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Icon(m.icon, color: m.color, size: 32),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color(0xFFB266B2),
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  m.desc,
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
                'Pilih metode KB sesuai kebutuhan dan konsultasikan ke tenaga kesehatan! 💙',
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

class _MetodeKB {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  _MetodeKB({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });
}
