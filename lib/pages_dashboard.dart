import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';

class PregnancyDashboardPage extends StatelessWidget {
  const PregnancyDashboardPage({super.key});

  int calculatePregnancyWeeks(DateTime lastPeriod) {
    final now = DateTime.now();
    final diff = now.difference(lastPeriod);
    return (diff.inDays / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    final lastPeriod = Get.find<LastPeriodController>().lastPeriodDate.value;
    final weeks = lastPeriod != null ? calculatePregnancyWeeks(lastPeriod) : 0;
    // HPL = hari terakhir haid + 9 bulan 10 hari
    String hplString = '-';
    if (lastPeriod != null) {
      final hpl = DateTime(
        lastPeriod.year,
        lastPeriod.month + 9,
        lastPeriod.day + 10,
      );
      hplString =
          "${hpl.day.toString().padLeft(2, '0')}-${hpl.month.toString().padLeft(2, '0')}-${hpl.year}";
    }
    // Status kehamilan berdasarkan minggu
    String statusTitle = '';
    String statusIbu = '';
    String statusJanin = '';
    if (weeks >= 1 && weeks <= 4) {
      statusTitle = 'Trimester 1 - Bulan 1 (Minggu 1-4)';
      statusIbu =
          'Mungkin belum menyadari hamil. Gejala awal seperti mual ringan, payudara sensitif, kelelahan mulai muncul.';
      statusJanin =
          'Proses pembuahan, pembentukan embrio, mulai terbentuk kantung kehamilan.';
    } else if (weeks >= 5 && weeks <= 8) {
      statusTitle = 'Trimester 1 - Bulan 2 (Minggu 5-8)';
      statusIbu = 'Morning sickness, mudah lelah, perubahan suasana hati.';
      statusJanin =
          'Organ-organ utama mulai berkembang, detak jantung bisa terdeteksi.';
    } else if (weeks >= 9 && weeks <= 12) {
      statusTitle = 'Trimester 1 - Bulan 3 (Minggu 9-12)';
      statusIbu = 'Mual bisa berkurang, berat badan mulai naik.';
      statusJanin =
          'Janin sudah berbentuk manusia kecil, organ vital terbentuk.';
    } else if (weeks >= 13 && weeks <= 16) {
      statusTitle = 'Trimester 2 - Bulan 4 (Minggu 13-16)';
      statusIbu =
          'Mual berkurang, nafsu makan meningkat, perut mulai membesar.';
      statusJanin =
          'Tulang mengeras, bisa mulai bergerak, jenis kelamin bisa mulai terlihat.';
    } else if (weeks >= 17 && weeks <= 20) {
      statusTitle = 'Trimester 2 - Bulan 5 (Minggu 17-20)';
      statusIbu =
          'Bisa merasakan gerakan janin pertama (quickening), kulit bisa jadi lebih sensitif.';
      statusJanin = 'Rambut halus (lanugo) tumbuh, sistem saraf berkembang.';
    } else if (weeks >= 21 && weeks <= 24) {
      statusTitle = 'Trimester 2 - Bulan 6 (Minggu 21-24)';
      statusIbu = 'Perut makin besar, bisa mulai mengalami sakit punggung.';
      statusJanin = 'Ukuran bertambah, kulit keriput, mulai mendengar suara.';
    } else if (weeks >= 25 && weeks <= 28) {
      statusTitle = 'Trimester 3 - Bulan 7 (Minggu 25-28)';
      statusIbu = 'Perut semakin besar, bisa mulai sulit tidur.';
      statusJanin = 'Paru-paru berkembang, bisa membuka dan menutup mata.';
    } else if (weeks >= 29 && weeks <= 32) {
      statusTitle = 'Trimester 3 - Bulan 8 (Minggu 29-32)';
      statusIbu = 'Sering buang air kecil, kelelahan, sesak napas.';
      statusJanin =
          'Berat badan naik cepat, posisi janin mulai stabil ke bawah.';
    } else if (weeks >= 33 && weeks <= 40) {
      statusTitle = 'Trimester 3 - Bulan 9 (Minggu 33-40)';
      statusIbu =
          'Siap melahirkan, kontraksi palsu (Braxton Hicks), tekanan di panggul.';
      statusJanin = 'Matang sepenuhnya, siap lahir kapan saja.';
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Kehamilan'),
        backgroundColor: const Color(0xFFFFB6C1),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFFF0F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cute pregnancy illustration
                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Icon(
                    Icons.child_friendly,
                    size: 64,
                    color: Colors.pink[200],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Umur Kehamilan',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: const Color(0xFFD291BC),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$weeks minggu',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF06292),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.pink[200],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Haid Terakhir: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      lastPeriod != null
                          ? "${lastPeriod.day.toString().padLeft(2, '0')}-${lastPeriod.month.toString().padLeft(2, '0')}-${lastPeriod.year}"
                          : "-",
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cake_rounded, color: Colors.pink[200], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'HPL: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      hplString,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (statusTitle.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.purple[200]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                statusTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.pregnant_woman, color: Colors.pink[300]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status Ibu:',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  Text(statusIbu, textAlign: TextAlign.justify),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.child_care, color: Colors.pink[300]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Janin:',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  Text(
                                    statusJanin,
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                // Cute motivational text
                Text(
                  'Tetap semangat, Bunda! 💖',
                  style: TextStyle(
                    color: Colors.pink[300],
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
