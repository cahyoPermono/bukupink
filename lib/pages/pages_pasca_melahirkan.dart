import 'package:flutter/material.dart';

class PascaMelahirkanPage extends StatelessWidget {
  const PascaMelahirkanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Pasca Melahirkan'),
        backgroundColor: const Color(0xFFFFC1CC),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
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
              child: const Icon(
                Icons.baby_changing_station,
                size: 56,
                color: Color(0xFFD291BC),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSubMenu(context),
        ],
      ),
    );
  }

  Widget _buildSubMenu(BuildContext context) {
    final List<_SubMenuItem> items = [
      _SubMenuItem(
        title: 'Pemantauan Nifas',
        icon: Icons.favorite_rounded,
        color: const Color(0xFFFFB6C1),
        description: 'Pantau masa nifas dan catat perubahan penting.',
        onTap:
            () => _showDetail(context, 'Pemantauan Nifas', [
              'Catat suhu tubuh, perdarahan, dan kondisi luka setiap hari.',
              'Perhatikan tanda infeksi: demam, bau tidak sedap, nyeri hebat.',
              'Pastikan istirahat cukup dan konsumsi makanan bergizi.',
            ]),
      ),
      _SubMenuItem(
        title: 'Konsumsi TTD/Vitamin A',
        icon: Icons.local_hospital_rounded,
        color: const Color(0xFFFFC1CC),
        description: 'Ingatkan konsumsi tablet tambah darah & vitamin A.',
        onTap:
            () => _showDetail(context, 'Konsumsi TTD/Vitamin A', [
              'Minum tablet tambah darah (TTD) sesuai anjuran bidan/dokter.',
              'Konsumsi vitamin A dosis tinggi setelah melahirkan.',
              'Catat waktu dan dosis konsumsi.',
            ]),
      ),
      _SubMenuItem(
        title: 'Tanda Bahaya Ibu dan Bayi',
        icon: Icons.warning_amber_rounded,
        color: const Color(0xFFF48FB1),
        description: 'Kenali tanda bahaya pada ibu & bayi baru lahir.',
        onTap:
            () => _showDetail(context, 'Tanda Bahaya Ibu dan Bayi', [
              'Ibu: perdarahan banyak, demam tinggi, kejang, nyeri hebat.',
              'Bayi: sulit menyusu, demam/hipotermia, napas cepat, kejang.',
              'Segera ke fasilitas kesehatan jika ada tanda bahaya.',
            ]),
      ),
    ];
    return Column(children: items.map((item) => _buildMenuCard(item)).toList());
  }

  Widget _buildMenuCard(_SubMenuItem item) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(14),
                child: Icon(item.icon, color: item.color, size: 32),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB266B2),
                        fontSize: 17,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        color: Color(0xFFAD1457),
                        fontSize: 14.5,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFD291BC)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, String title, List<String> details) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFF0F6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD291BC),
                    fontSize: 18,
                    fontFamily: 'Nunito',
                  ),
                ),
                const SizedBox(height: 16),
                ...details.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            color: Color(0xFFB266B2),
                            fontSize: 16,
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
    );
  }
}

class _SubMenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final VoidCallback onTap;

  _SubMenuItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.onTap,
  });
}
