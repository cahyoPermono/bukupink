import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';
import 'pages_lastperiod.dart';
import 'pages_dashboard.dart';
import 'services_pregnancy.dart';

class PregnancyListPage extends StatefulWidget {
  const PregnancyListPage({super.key});

  @override
  State<PregnancyListPage> createState() => _PregnancyListPageState();
}

class _PregnancyListPageState extends State<PregnancyListPage> {
  List<Pregnancy> pregnancies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPregnancies();
  }

  Future<void> fetchPregnancies() async {
    final data = await PregnancyService.getAllPregnancies();
    setState(() {
      pregnancies = data;
      isLoading = false;
    });
  }

  void addPregnancy(Pregnancy pregnancy) async {
    await PregnancyService.insertPregnancy(pregnancy);
    fetchPregnancies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kehamilan'), centerTitle: true),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child:
                        pregnancies.isEmpty
                            ? const Center(
                              child: Text('Belum ada kehamilan terdaftar.'),
                            )
                            : ListView.builder(
                              itemCount: pregnancies.length,
                              itemBuilder: (context, index) {
                                final pregnancy = pregnancies[index];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.favorite,
                                    color: Color(0xFFFFB6C1),
                                  ),
                                  title: Text(pregnancy.name),
                                  subtitle: Text('Tanggal: ${pregnancy.date}'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                const PregnancyDashboardPage(),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Kehamilan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFB6C1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final lastPeriod =
                              Get.find<LastPeriodController>()
                                  .lastPeriodDate
                                  .value;
                          if (lastPeriod == null) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LastPeriodFormPage(),
                              ),
                            );
                            // Setelah input tanggal haid, refresh list
                            fetchPregnancies();
                          } else {
                            // Tambah kehamilan baru ke database
                            final pregnancy = Pregnancy(
                              name: 'Kehamilan ${pregnancies.length + 1}',
                              date:
                                  '${lastPeriod.year}-${lastPeriod.month.toString().padLeft(2, '0')}-${lastPeriod.day.toString().padLeft(2, '0')}',
                            );
                            await PregnancyService.insertPregnancy(pregnancy);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PregnancyDashboardPage(),
                              ),
                            );
                            fetchPregnancies();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
