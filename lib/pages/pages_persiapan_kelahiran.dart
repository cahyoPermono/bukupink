import 'package:flutter/material.dart';

class PersiapanKelahiranPage extends StatelessWidget {
  const PersiapanKelahiranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Persiapan Kelahiran'),
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
                Icons.child_friendly,
                size: 56,
                color: Color(0xFFD291BC),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Checklist Persiapan Kelahiran',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFD291BC),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: _buildChecklist(),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Tanda-tanda Melahirkan',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFD291BC),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: _buildTandaTanda(),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Semangat ya, Bunda! 💖',
              style: TextStyle(
                color: Colors.pink[300],
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'Nunito',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklist() {
    final items = [
      'KTP & dokumen penting',
      'Buku KIA/Buku Pink',
      'Hasil pemeriksaan kehamilan',
      'Pakaian ibu & bayi',
      'Popok bayi',
      'Perlengkapan mandi bayi',
      'Perlengkapan menyusui',
      'Uang secukupnya',
      'Handphone & charger',
      'Masker & hand sanitizer',
      'Transportasi ke fasilitas kesehatan',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC1CC),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFB266B2),
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildTandaTanda() {
    final items = [
      'Kontraksi teratur dan semakin sering',
      'Keluar lendir bercampur darah dari jalan lahir',
      'Air ketuban pecah',
      'Nyeri punggung bagian bawah',
      'Tekanan di panggul meningkat',
      'Mual atau diare',
      'Gerakan janin berkurang',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD291BC),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFB266B2),
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }
}
