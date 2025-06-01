import 'package:flutter/material.dart';
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
                                return Dismissible(
                                  key: ValueKey(pregnancy.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFF0F6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Color(0xFFF06292),
                                      size: 32,
                                    ),
                                  ),
                                  confirmDismiss: (direction) async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            backgroundColor: const Color(
                                              0xFFFFF0F6,
                                            ),
                                            title: const Text(
                                              'Konfirmasi',
                                              style: TextStyle(
                                                color: Color(0xFFF06292),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: const Text(
                                              'Yakin ingin menghapus kehamilan ini? 🍼',
                                              style: TextStyle(
                                                color: Color(0xFFAD1457),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text(
                                                  'Batal',
                                                  style: TextStyle(
                                                    color: Color(0xFFF06292),
                                                  ),
                                                ),
                                                onPressed:
                                                    () => Navigator.of(
                                                      context,
                                                    ).pop(false),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(
                                                    0xFFF06292,
                                                  ),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                child: const Text('Hapus'),
                                                onPressed:
                                                    () => Navigator.of(
                                                      context,
                                                    ).pop(true),
                                              ),
                                            ],
                                          ),
                                    );
                                    return confirm == true;
                                  },
                                  onDismissed: (direction) async {
                                    await PregnancyService.deletePregnancy(
                                      pregnancy.id,
                                    );
                                    setState(() {
                                      pregnancies.removeAt(index);
                                    });
                                  },
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.favorite,
                                      color: Color(0xFFFFB6C1),
                                    ),
                                    title: Text(pregnancy.name),
                                    subtitle: Text(
                                      'Tanggal: ${pregnancy.date}',
                                    ),
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
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Color(0xFFF48FB1),
                                      ),
                                      tooltip: 'Hapus',
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                backgroundColor: const Color(
                                                  0xFFFFF0F6,
                                                ),
                                                title: const Text(
                                                  'Konfirmasi',
                                                  style: TextStyle(
                                                    color: Color(0xFFF06292),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: const Text(
                                                  'Yakin ingin menghapus kehamilan ini? 🍼',
                                                  style: TextStyle(
                                                    color: Color(0xFFAD1457),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text(
                                                      'Batal',
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFFF06292,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed:
                                                        () => Navigator.of(
                                                          context,
                                                        ).pop(false),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Color(
                                                        0xFFF06292,
                                                      ),
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    child: const Text('Hapus'),
                                                    onPressed:
                                                        () => Navigator.of(
                                                          context,
                                                        ).pop(true),
                                                  ),
                                                ],
                                              ),
                                        );
                                        if (confirm == true) {
                                          await PregnancyService.deletePregnancy(
                                            pregnancy.id,
                                          );
                                          setState(() {
                                            pregnancies.removeAt(index);
                                          });
                                        }
                                      },
                                    ),
                                  ),
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
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LastPeriodFormPage(),
                            ),
                          );
                          // Setelah input tanggal haid, refresh list
                          fetchPregnancies();
                        },
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
