import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KesehatanMentalIbuPage extends StatelessWidget {
  const KesehatanMentalIbuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Kesehatan Mental Ibu'),
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
                      Icons.self_improvement,
                      size: 60,
                      color: Colors.purple[200],
                    ),
              ),
            ),
            const SizedBox(height: 28),
            _CuteMenuCard(
              icon: Icons.psychology_alt,
              title: 'Screening Gejala',
              color: Color(0xFF9575CD),
              onTap: () async {
                final result = await showModalBottomSheet<_ScreeningResult>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  builder: (context) => const _ScreeningSheet(),
                );
                if (result != null && result.isRisk) {
                  // Tampilkan dialog saran konseling dengan GetX, lebih cantik
                  Get.defaultDialog(
                    titlePadding: const EdgeInsets.only(top: 32, bottom: 0),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    radius: 24,
                    title: '',
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF9575CD,
                            ).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(18),
                          child: const Icon(
                            Icons.volunteer_activism,
                            color: Color(0xFF9575CD),
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Perlu Dukungan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF9575CD),
                            fontFamily: 'Nunito',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Hasil screening menunjukkan Bunda mungkin mengalami gejala stres atau baby blues. Jangan ragu untuk mencari dukungan dari keluarga atau tenaga profesional. 💜',
                          style: TextStyle(
                            fontSize: 15.5,
                            color: Color(0xFF6D4C9B),
                            fontFamily: 'Nunito',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF9575CD),
                                  elevation: 0,
                                  side: const BorderSide(
                                    color: Color(0xFF9575CD),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () => Get.back(),
                                child: const Text('Tutup'),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9575CD),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Get.back();
                                  Get.toNamed('/konseling-rujukan');
                                },
                                child: const Text('Lihat Konseling'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                    barrierDismissible: false,
                  );
                } else if (result != null && !result.isRisk) {
                  // Dialog hasil screening bagus
                  Get.defaultDialog(
                    titlePadding: const EdgeInsets.only(top: 32, bottom: 0),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    radius: 24,
                    title: '',
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF4FC3F7,
                            ).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(18),
                          child: const Icon(
                            Icons.emoji_emotions,
                            color: Color(0xFF4FC3F7),
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Hasil Screening Bagus!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF4FC3F7),
                            fontFamily: 'Nunito',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Selamat, Bunda! Tidak ditemukan gejala yang mengkhawatirkan. Tetap jaga kesehatan mental dan fisik, serta jangan ragu untuk mencari dukungan jika dibutuhkan. 💜',
                          style: TextStyle(
                            fontSize: 15.5,
                            color: Color(0xFF1976D2),
                            fontFamily: 'Nunito',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4FC3F7),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () => Get.back(),
                            child: const Text('Tutup'),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                    barrierDismissible: false,
                  );
                }
              },
            ),
            const SizedBox(height: 18),
            _CuteMenuCard(
              icon: Icons.support_agent,
              title: 'Konseling / Rujukan',
              color: Color(0xFF4FC3F7),
              onTap: () => Navigator.pushNamed(context, '/konseling-rujukan'),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Kesehatan mental ibu sama pentingnya dengan fisik. Jangan ragu untuk mencari bantuan! 💜',
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

// --- Screening Sheet ---
class _ScreeningSheet extends StatefulWidget {
  const _ScreeningSheet();
  @override
  State<_ScreeningSheet> createState() => _ScreeningSheetState();
}

class _ScreeningSheetState extends State<_ScreeningSheet> {
  final List<_ScreeningQuestion> _questions = [
    _ScreeningQuestion(
      'Sering merasa sedih, cemas, atau mudah menangis tanpa sebab jelas?',
    ),
    _ScreeningQuestion('Sulit tidur meski bayi sedang tidur?'),
    _ScreeningQuestion('Merasa lelah berlebihan atau tidak berenergi?'),
    _ScreeningQuestion('Kehilangan minat pada hal-hal yang biasanya disukai?'),
    _ScreeningQuestion('Mudah marah atau tersinggung?'),
    _ScreeningQuestion('Merasa tidak mampu menjadi ibu yang baik?'),
    _ScreeningQuestion('Pikiran negatif tentang diri sendiri atau bayi?'),
  ];
  final Map<int, bool> _answers = {};
  bool _submitted = false;

  int get _score => _answers.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 6,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const Text(
            'Screening Gejala Baby Blues/Stres',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFFB266B2),
              fontFamily: 'Nunito',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          ..._questions.asMap().entries.map((entry) {
            final i = entry.key;
            final q = entry.value;
            return Card(
              color: Colors.white,
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(Icons.psychology, color: Color(0xFF9575CD)),
                title: Text(q.text, style: const TextStyle(fontSize: 15.5)),
                trailing: Switch(
                  value: _answers[i] ?? false,
                  activeColor: Color(0xFF9575CD),
                  onChanged:
                      _submitted
                          ? null
                          : (v) => setState(() => _answers[i] = v),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9575CD),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed:
                _submitted
                    ? null
                    : () {
                      setState(() => _submitted = true);
                      final isRisk = _score >= 3;
                      Navigator.pop(context, _ScreeningResult(isRisk: isRisk));
                    },
            child: const Text('Lihat Hasil'),
          ),
          if (_submitted) ...[
            const SizedBox(height: 16),
            Center(
              child: Text(
                _score >= 3
                    ? 'Bunda mungkin mengalami gejala baby blues/stres. Konsultasikan ke tenaga profesional.'
                    : 'Hasil screening normal. Tetap jaga kesehatan mental ya, Bunda!',
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
        ],
      ),
    );
  }
}

class _ScreeningQuestion {
  final String text;
  _ScreeningQuestion(this.text);
}

class _ScreeningResult {
  final bool isRisk;
  _ScreeningResult({required this.isRisk});
}
