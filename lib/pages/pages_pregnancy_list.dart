import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'pages_lastperiod.dart';
import 'pages_dashboard.dart';
import '../services/services_pregnancy.dart';

class PregnancyListPage extends StatefulWidget {
  const PregnancyListPage({super.key});

  @override
  State<PregnancyListPage> createState() => _PregnancyListPageState();
}

class _PregnancyListPageState extends State<PregnancyListPage> {
  List<Pregnancy> pregnancies = [];
  bool isLoading = true;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Inisialisasi timezone
    _initNotifications();
    fetchPregnancies();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Fungsi untuk menjadwalkan notifikasi bulanan hingga bulan ke-9
  Future<void> scheduleMonthlyReminders(Pregnancy pregnancy) async {
    final startDate = DateTime.parse(pregnancy.date);
    final location = tz.local;
    for (int i = 1; i <= 9; i++) {
      final reminderDate = tz.TZDateTime(
        location,
        startDate.year,
        startDate.month + i,
        startDate.day,
        9, // jam 9 pagi
      );
      if (reminderDate.isAfter(tz.TZDateTime.now(location))) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          pregnancy.hashCode + i, // unique id
          'Reminder Kehamilan Bulan ke-$i',
          'Jangan lupa cek perkembangan kehamilan bulan ke-$i! di Dokter atau Bidan Terdekat',
          reminderDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'pregnancy_channel',
              'Reminder Kehamilan',
              channelDescription: 'Notifikasi bulanan kehamilan',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode:
              AndroidScheduleMode.exactAllowWhileIdle, // Tambahkan baris ini
        );
      }
    }
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
    await scheduleMonthlyReminders(pregnancy);
    fetchPregnancies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Daftar Kehamilan'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC1CC),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LastPeriodFormPage()),
          );
          fetchPregnancies();
        },
        backgroundColor: const Color(0xFFFFB6C1),
        icon: const Icon(Icons.add, color: Color(0xFFD291BC)),
        label: const Text(
          'Tambah',
          style: TextStyle(
            color: Color(0xFFD291BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  if (pregnancies.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 8),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.pink[50],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pinkAccent.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(22),
                            child: const Icon(
                              Icons.favorite_rounded,
                              size: 48,
                              color: Color(0xFFD291BC),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Riwayat Kehamilan',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              color: const Color(0xFFD291BC),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Pantau dan simpan perjalanan kehamilanmu di sini',
                            style: TextStyle(
                              color: Color(0xFFB266B2),
                              fontSize: 15,
                              fontFamily: 'Nunito',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child:
                        pregnancies.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/empty_pregnancy.png',
                                    height: 120,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Belum ada kehamilan terdaftar',
                                    style: TextStyle(
                                      color: Color(0xFFD291BC),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Yuk, tambahkan kehamilan pertamamu! 🍼',
                                    style: TextStyle(
                                      color: Color(0xFFB266B2),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: pregnancies.length,
                              itemBuilder: (context, index) {
                                final pregnancy = pregnancies[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Dismissible(
                                    key: ValueKey(pregnancy.id),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE0F0),
                                        borderRadius: BorderRadius.circular(20),
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
                                                    backgroundColor:
                                                        const Color(0xFFF06292),
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
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 20,
                                            ),
                                        leading: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFC1CC),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: const Icon(
                                            Icons.cake_rounded,
                                            color: Color(0xFFD291BC),
                                            size: 28,
                                          ),
                                        ),
                                        title: Text(
                                          pregnancy.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFB266B2),
                                            fontSize: 17,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                          ),
                                          child: Text(
                                            'Tanggal: 	${pregnancy.date}',
                                            style: const TextStyle(
                                              color: Color(0xFFAD1457),
                                              fontSize: 14.5,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          final dateParts = pregnancy.date
                                              .split('-');
                                          final period = DateTime(
                                            int.parse(dateParts[0]),
                                            int.parse(dateParts[1]),
                                            int.parse(dateParts[2]),
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => PregnancyDashboardPage(
                                                    lastPeriod: period,
                                                  ),
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
                                            final confirm = await showDialog<
                                              bool
                                            >(
                                              context: context,
                                              builder:
                                                  (context) => AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    backgroundColor:
                                                        const Color(0xFFFFF0F6),
                                                    title: const Text(
                                                      'Konfirmasi',
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFFF06292,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    content: const Text(
                                                      'Yakin ingin menghapus kehamilan ini? 🍼',
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFFAD1457,
                                                        ),
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
                                                          backgroundColor:
                                                              const Color(
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
                                                        child: const Text(
                                                          'Hapus',
                                                        ),
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
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
