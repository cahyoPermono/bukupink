import 'package:flutter/material.dart';

class PosisiMenyusuiPage extends StatelessWidget {
  const PosisiMenyusuiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_BreastfeedingPosition> positions = [
      _BreastfeedingPosition(
        title: 'Cradle Hold',
        image: 'assets/icons/cradle_hold.png',
        description: [
          'Posisi klasik, bayi diletakkan di lengan ibu, kepala bayi di lekukan siku.',
          'Pastikan perut bayi menempel ke perut ibu.',
          'Bayi menghadap ke payudara, hidung sejajar puting.',
        ],
      ),
      _BreastfeedingPosition(
        title: 'Cross-Cradle Hold',
        image: 'assets/icons/cross_cradle.png',
        description: [
          'Mirip cradle, tapi lengan berlawanan menopang kepala bayi.',
          'Cocok untuk bayi baru lahir atau belajar latch.',
        ],
      ),
      _BreastfeedingPosition(
        title: 'Football Hold',
        image: 'assets/icons/football_hold.png',
        description: [
          'Bayi di samping tubuh ibu, ditopang lengan dan tangan.',
          'Cocok untuk ibu pasca operasi caesar.',
        ],
      ),
      _BreastfeedingPosition(
        title: 'Side-Lying',
        image: 'assets/icons/side_lying.png',
        description: [
          'Ibu dan bayi berbaring miring saling berhadapan.',
          'Nyaman untuk menyusui malam hari.',
        ],
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Posisi Menyusui'),
        backgroundColor: const Color(0xFFFFC1CC),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: positions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 22),
        itemBuilder: (context, i) {
          final pos = positions[i];
          return Card(
            color: Colors.white,
            elevation: 2.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Image.asset(
                      pos.image,
                      height: 48,
                      width: 48,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (c, o, s) => Icon(
                            Icons.baby_changing_station,
                            color: Color(0xFFFFB6C1),
                            size: 32,
                          ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pos.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xFFB266B2),
                            fontFamily: 'Nunito',
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...pos.description.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}

class _BreastfeedingPosition {
  final String title;
  final String image;
  final List<String> description;
  _BreastfeedingPosition({
    required this.title,
    required this.image,
    required this.description,
  });
}
