import 'package:flutter/material.dart';

class TipsNutrisiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<_TipsNutrisi> tips = [
      _TipsNutrisi(
        icon: Icons.water_drop,
        color: Color(0xFF81C784),
        title: 'Cukupi Cairan Tubuh',
        desc:
            'Minum air putih minimal 8 gelas/hari untuk menjaga produksi ASI.',
      ),
      _TipsNutrisi(
        icon: Icons.restaurant,
        color: Color(0xFFFFE082),
        title: 'Makan Makanan Bergizi',
        desc:
            'Konsumsi makanan beragam: karbohidrat, protein, lemak sehat, sayur, buah.',
      ),
      _TipsNutrisi(
        icon: Icons.egg,
        color: Color(0xFFFFB6C1),
        title: 'Perbanyak Protein',
        desc:
            'Sumber protein: telur, ikan, ayam, tempe, tahu, kacang-kacangan.',
      ),
      _TipsNutrisi(
        icon: Icons.no_food,
        color: Color(0xFFF48FB1),
        title: 'Batasi Kafein & Hindari Alkohol',
        desc: 'Batasi kopi/teh, hindari alkohol & rokok demi kualitas ASI.',
      ),
      _TipsNutrisi(
        icon: Icons.medical_services,
        color: Color(0xFF9575CD),
        title: 'Konsumsi Suplemen Jika Diperlukan',
        desc:
            'Konsultasikan ke tenaga kesehatan untuk kebutuhan vitamin/mineral tambahan.',
      ),
      _TipsNutrisi(
        icon: Icons.sentiment_satisfied_alt,
        color: Color(0xFF4FC3F7),
        title: 'Jaga Mood & Istirahat',
        desc: 'Ibu bahagia, ASI lancar! Istirahat cukup dan kelola stres.',
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Tips Nutrisi Ibu Menyusui'),
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
                'assets/icons/healthy_mom.png',
                height: 80,
                errorBuilder:
                    (c, o, s) => Icon(
                      Icons.local_dining,
                      size: 60,
                      color: Colors.pink[200],
                    ),
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: ListView.separated(
                itemCount: tips.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final t = tips[i];
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
                              color: t.color.withOpacity(0.16),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Icon(t.icon, color: t.color, size: 32),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color(0xFFB266B2),
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  t.desc,
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
                'Nutrisi seimbang bantu ibu & bayi tumbuh optimal! 💕',
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

class _TipsNutrisi {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  _TipsNutrisi({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });
}
