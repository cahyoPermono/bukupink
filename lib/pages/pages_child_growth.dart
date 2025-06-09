import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../services/db.dart';

class ChildGrowthPage extends StatelessWidget {
  final Map<String, dynamic> child;
  const ChildGrowthPage({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: Text('Pemantauan: ${child['nama']}'),
        backgroundColor: const Color(0xFFFFB6C1),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color:
                    child['jenis_kelamin'] == 'L'
                        ? Colors.blue[50]
                        : Colors.pink[50],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withAlpha((0.08 * 255).toInt()),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(28),
              child: Icon(
                child['jenis_kelamin'] == 'L' ? Icons.boy : Icons.girl,
                size: 56,
                color:
                    child['jenis_kelamin'] == 'L'
                        ? Colors.blue[300]
                        : Colors.pink[200],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              child['nama'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFFB266B2),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Lahir: ${child['tanggal_lahir']}',
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFFB266B2),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 28),
          _MenuCard(
            title: 'Cek Berat Badan / Tinggi',
            icon: Icons.monitor_weight,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WeightHeightCheckPage(childId: child['id']),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          _MenuCard(
            title: 'Jadwal Imunisasi',
            icon: Icons.vaccines,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ImmunizationSchedulePage(childId: child['id']),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          _MenuCard(
            title: 'Perkembangan Anak',
            icon: Icons.child_care,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChildDevelopmentPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Icon(icon, color: Colors.pink[300], size: 32),
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
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFD291BC),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder pages for each feature
class WeightHeightCheckPage extends StatefulWidget {
  final int childId;
  const WeightHeightCheckPage({required this.childId, super.key});
  @override
  State<WeightHeightCheckPage> createState() => _WeightHeightCheckPageState();
}

class _WeightHeightCheckPageState extends State<WeightHeightCheckPage>
    with SingleTickerProviderStateMixin {
  List<_GrowthEntry> _entries = [];
  final _dateController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadGrowth();
  }

  Future<void> _loadGrowth() async {
    final db = await DB.database;
    final data = await db.query(
      'growth',
      where: 'anak_id = ?',
      whereArgs: [widget.childId],
      orderBy: 'tanggal',
    );
    setState(() {
      _entries =
          data
              .map(
                (e) => _GrowthEntry(
                  date: e['tanggal'] as String,
                  weight: (e['berat'] as num).toDouble(),
                  height: (e['tinggi'] as num).toDouble(),
                ),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _showAddEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final formKeyDialog = GlobalKey<FormState>();
        final dateControllerDialog = TextEditingController();
        final weightControllerDialog = TextEditingController();
        final heightControllerDialog = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Tambah Data Berat/Tinggi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFB266B2),
            ),
          ),
          content: SizedBox(
            width: 320,
            child: Form(
              key: formKeyDialog,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: dateControllerDialog,
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      hintText: 'YYYY-MM-DD',
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFD291BC),
                      ),
                      filled: true,
                      fillColor: Colors.pink[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: const TextStyle(
                        color: Color(0xFFB266B2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        dateControllerDialog.text =
                            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                      }
                    },
                    validator:
                        (v) => v == null || v.isEmpty ? 'Isi tanggal' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: weightControllerDialog,
                    decoration: InputDecoration(
                      labelText: 'Berat (kg)',
                      prefixIcon: const Icon(
                        Icons.monitor_weight,
                        color: Color(0xFFD291BC),
                      ),
                      filled: true,
                      fillColor: Colors.pink[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: const TextStyle(
                        color: Color(0xFFB266B2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator:
                        (v) => v == null || v.isEmpty ? 'Isi berat' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: heightControllerDialog,
                    decoration: InputDecoration(
                      labelText: 'Tinggi (cm)',
                      prefixIcon: const Icon(
                        Icons.height,
                        color: Color(0xFFD291BC),
                      ),
                      filled: true,
                      fillColor: Colors.pink[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: const TextStyle(
                        color: Color(0xFFB266B2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator:
                        (v) => v == null || v.isEmpty ? 'Isi tinggi' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF81C784),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (formKeyDialog.currentState!.validate()) {
                  final db = await DB.database;
                  await db.insert('growth', {
                    'anak_id': widget.childId,
                    'tanggal': dateControllerDialog.text,
                    'berat': double.parse(weightControllerDialog.text),
                    'tinggi': double.parse(heightControllerDialog.text),
                  });
                  Get.back();
                  _loadGrowth();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Cek Berat Badan / Tinggi'),
        backgroundColor: const Color(0xFFFFB6C1),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFFFFB6C1),
                borderRadius: BorderRadius.circular(14),
              ),
              indicatorWeight: 0,
              labelColor: const Color(0xFFB266B2),
              unselectedLabelColor: const Color(0xFFD291BC),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.5,
                fontFamily: 'Nunito',
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.5,
                fontFamily: 'Nunito',
              ),
              tabs: const [Tab(text: 'Tabel'), Tab(text: 'Grafik')],
              splashFactory: InkRipple.splashFactory,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withAlpha((0.08 * 255).toInt()),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB266B2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Data Berat/Tinggi'),
                    onPressed: () => _showAddEntryDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Tabel
                  _entries.isEmpty
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/cute_baby.png',
                            height: 90,
                            errorBuilder:
                                (c, o, s) => Icon(
                                  Icons.monitor_weight,
                                  size: 60,
                                  color: Colors.pink[200],
                                ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada data.',
                            style: TextStyle(
                              color: Color(0xFFD291BC),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                      : ListView(
                        children: [
                          DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFFFF0F6),
                            ),
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Tanggal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB266B2),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Berat',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB266B2),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Tinggi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB266B2),
                                  ),
                                ),
                              ),
                            ],
                            rows:
                                _entries
                                    .map(
                                      (e) => DataRow(
                                        cells: [
                                          DataCell(Text(e.date)),
                                          DataCell(
                                            Text(e.weight.toStringAsFixed(1)),
                                          ),
                                          DataCell(
                                            Text(e.height.toStringAsFixed(1)),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                  // Tab 2: Grafik
                  Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pinkAccent.withAlpha(
                                  (0.07 * 255).toInt(),
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              const Text(
                                'Grafik Berat Badan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB266B2),
                                ),
                              ),
                              SizedBox(
                                height: 180,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _SimpleLineChart(
                                    entries: _entries,
                                    isWeight: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pinkAccent.withAlpha(
                                  (0.07 * 255).toInt(),
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              const Text(
                                'Grafik Tinggi Badan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB266B2),
                                ),
                              ),
                              SizedBox(
                                height: 180,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _SimpleLineChart(
                                    entries: _entries,
                                    isWeight: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrowthEntry {
  final String date;
  final double weight;
  final double height;
  _GrowthEntry({
    required this.date,
    required this.weight,
    required this.height,
  });
}

class _SimpleLineChart extends StatelessWidget {
  final List<_GrowthEntry> entries;
  final bool isWeight;
  const _SimpleLineChart({required this.entries, required this.isWeight});

  @override
  Widget build(BuildContext context) {
    if (entries.length < 2) {
      return const Center(child: Text('Belum cukup data untuk grafik.'));
    }
    // Cari min dan max value untuk weight/height
    final values = entries.map((e) => isWeight ? e.weight : e.height).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    // Untuk tinggi, pastikan maxValue minimal 200 agar skala cukup
    final double chartMax =
        isWeight ? (maxValue + 2) : ((maxValue > 180 ? maxValue + 10 : 200));
    final double chartMin =
        isWeight ? (minValue - 2 < 0 ? 0 : minValue - 2) : 0;
    final double chartHeight = 180;
    final double chartWidth = (entries.length - 1) * 40.0 + 40;
    final points =
        entries.asMap().entries.map((e) {
          final value = isWeight ? e.value.weight : e.value.height;
          final y =
              chartHeight -
              ((value - chartMin) / (chartMax - chartMin) * chartHeight);
          return Offset(e.key * 40.0 + 20, y);
        }).toList();
    return Stack(
      children: [
        CustomPaint(
          painter: _LineChartPainter(
            points: points,
            isWeight: isWeight,
            minValue: chartMin,
            maxValue: chartMax,
            entries: entries,
          ),
          size: Size(chartWidth, chartHeight),
        ),
        // Tambahkan label angka di sumbu Y
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i <= 4; i++)
                Text(
                  (chartMax - (i * (chartMax - chartMin) / 4)).toStringAsFixed(
                    0,
                  ),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFB266B2),
                  ),
                ),
            ],
          ),
        ),
        // Tambahkan label tanggal di bawah tiap titik
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < entries.length; i++)
                SizedBox(
                  width: 40,
                  child: Text(
                    entries[i].date.substring(5),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFD291BC),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<Offset> points;
  final bool isWeight;
  final double minValue;
  final double maxValue;
  final List<_GrowthEntry> entries;
  _LineChartPainter({
    required this.points,
    required this.isWeight,
    required this.minValue,
    required this.maxValue,
    required this.entries,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = isWeight ? Colors.pink : Colors.green
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
    if (points.length > 1) {
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      canvas.drawCircle(p, 4, Paint()..color = paint.color);
      // Tambahkan angka di atas titik
      final value = isWeight ? entries[i].weight : entries[i].height;
      final tp = TextPainter(
        text: TextSpan(
          text: value.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFB266B2),
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(p.dx - tp.width / 2, p.dy - 18));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ImmunizationSchedulePage extends StatefulWidget {
  final int childId;
  const ImmunizationSchedulePage({required this.childId, super.key});
  @override
  State<ImmunizationSchedulePage> createState() =>
      _ImmunizationSchedulePageState();
}

class _ImmunizationSchedulePageState extends State<ImmunizationSchedulePage> {
  List<_ImmunizationEntry> _immunizations = [];
  final _nameController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _notifInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadImunisasi();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    if (_notifInitialized) return;
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _notifInitialized = true;
  }

  Future<void> _scheduleImmunizationReminder(_ImmunizationEntry item) async {
    if (item.date.isEmpty) return;
    final location = tz.local;
    final dateParts = item.date.split('-');
    if (dateParts.length != 3) return;
    final year = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final day = int.tryParse(dateParts[2]);
    if (year == null || month == null || day == null) return;
    // Cancel previous notifications for this immunization (4 ids)
    for (int offset in [0, 1, 2, 3]) {
      await flutterLocalNotificationsPlugin.cancel(
        (item.id ?? item.hashCode) * 10 + offset,
      );
    }
    // Schedule notifications for H-7, H-3, H-1, and H
    final List<int> daysBefore = [7, 3, 1, 0];
    final List<String> messages = [
      'Imunisasi ${item.name} tinggal 7 hari lagi!',
      'Imunisasi ${item.name} tinggal 3 hari lagi!',
      'Imunisasi ${item.name} besok, jangan lupa!',
      'Jangan lupa imunisasi: ${item.name} hari ini!',
    ];
    for (int i = 0; i < daysBefore.length; i++) {
      final notifDate = tz.TZDateTime(
        location,
        year,
        month,
        day,
        8,
      ).subtract(Duration(days: daysBefore[i]));
      if (notifDate.isAfter(tz.TZDateTime.now(location))) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          (item.id ?? item.hashCode) * 10 + i,
          'Jadwal Imunisasi',
          messages[i],
          notifDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'imunisasi_channel',
              'Reminder Imunisasi',
              channelDescription: 'Notifikasi jadwal imunisasi anak',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      }
    }
  }

  void _addImmunization() async {
    if (_nameController.text.trim().isNotEmpty) {
      final db = await DB.database;
      await db.insert('imunisasi', {
        'anak_id': widget.childId,
        'nama': _nameController.text.trim(),
        'tanggal': '',
        'done': 0,
      });
      _nameController.clear();
      _loadImunisasi();
    }
  }

  void _removeImmunization(int index) async {
    final db = await DB.database;
    await db.delete(
      'imunisasi',
      where: 'id = ?',
      whereArgs: [_immunizations[index].id],
    );
    _loadImunisasi();
  }

  void _toggleDone(int index, bool? value) async {
    final db = await DB.database;
    final item = _immunizations[index];
    await db.update(
      'imunisasi',
      {'done': value == true ? 1 : 0},
      where: 'id = ?',
      whereArgs: [item.id],
    );
    setState(() {
      item.done = value ?? false;
    });
  }

  void _setDate(int index, String date) async {
    final db = await DB.database;
    final item = _immunizations[index];
    await db.update(
      'imunisasi',
      {'tanggal': date},
      where: 'id = ?',
      whereArgs: [item.id],
    );
    setState(() {
      item.date = date;
    });
    await _scheduleImmunizationReminder(item);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder imunisasi sudah dijadwalkan!')),
      );
    }
  }

  Future<void> _loadImunisasi() async {
    final db = await DB.database;
    final data = await db.query(
      'imunisasi',
      where: 'anak_id = ?',
      whereArgs: [widget.childId],
    );
    setState(() {
      _immunizations =
          data
              .map(
                (e) => _ImmunizationEntry(
                  name: e['nama'] as String,
                  date: e['tanggal'] as String,
                  done: (e['done'] as int) == 1,
                  id: e['id'] as int,
                ),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Jadwal Imunisasi'),
        backgroundColor: const Color(0xFFFFB6C1),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withAlpha((0.07 * 255).toInt()),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Tambah Imunisasi',
                        labelStyle: const TextStyle(
                          color: Color(0xFFB266B2),
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Container(
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFFD291BC),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.pink[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 8,
                        ),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB266B2),
                      ),
                      onSubmitted: (_) => _addImmunization(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF81C784),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: _addImmunization,
                      tooltip: 'Tambah',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Expanded(
              child:
                  _immunizations.isEmpty
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/cute_baby.png',
                            height: 100,
                            errorBuilder:
                                (c, o, s) => Icon(
                                  Icons.vaccines,
                                  size: 60,
                                  color: Colors.pink[200],
                                ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Belum ada jadwal imunisasi.',
                            style: TextStyle(
                              color: Color(0xFFD291BC),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                      : ListView.separated(
                        itemCount: _immunizations.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, i) {
                          final item = _immunizations[i];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pinkAccent.withAlpha(
                                    (0.07 * 255).toInt(),
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              leading: GestureDetector(
                                onTap: () => _toggleDone(i, !item.done),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        item.done
                                            ? const Color(0xFF81C784)
                                            : Colors.pink[50],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          item.done
                                              ? const Color(0xFF81C784)
                                              : const Color(0xFFD291BC),
                                      width: 2,
                                    ),
                                  ),
                                  width: 32,
                                  height: 32,
                                  child:
                                      item.done
                                          ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                          : const Icon(
                                            Icons.circle_outlined,
                                            color: Color(0xFFD291BC),
                                            size: 20,
                                          ),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB266B2),
                                  fontSize: 16,
                                ),
                              ),
                              subtitle:
                                  item.date.isNotEmpty
                                      ? Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 18,
                                              color: Color(0xFFD291BC),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.date,
                                              style: const TextStyle(
                                                color: Color(0xFFD291BC),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.pink[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.calendar_month,
                                        color: Color(0xFFD291BC),
                                      ),
                                      tooltip: 'Pilih tanggal',
                                      onPressed: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              item.date.isNotEmpty
                                                  ? DateTime.parse(item.date)
                                                  : DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );
                                        if (picked != null) {
                                          _setDate(
                                            i,
                                            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}',
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.pink[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      tooltip: 'Hapus',
                                      onPressed: () => _removeImmunization(i),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImmunizationEntry {
  String name;
  String date;
  bool done;
  int? id;
  _ImmunizationEntry({
    required this.name,
    required this.date,
    required this.done,
    this.id,
  });
}

class _DevData {
  final IconData icon;
  final Color color;
  final String title;
  final List<String> description;
  _DevData({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });
}

extension ColorShade on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

class ChildDevelopmentPage extends StatelessWidget {
  const ChildDevelopmentPage({super.key});
  @override
  Widget build(BuildContext context) {
    final List<_DevData> devs = [
      _DevData(
        icon: Icons.cake,
        color: Color(0xFFFFB6C1),
        title: '0-6 Bulan',
        description: [
          'Mengangkat kepala saat tengkurap',
          'Mulai tersenyum sosial',
          'Menggenggam benda',
          'Mengeluarkan suara (cooing)',
          'Mengikuti benda dengan mata',
          'Mulai membalikkan badan',
        ],
      ),
      _DevData(
        icon: Icons.child_friendly,
        color: Color(0xFFB2DFDB),
        title: '6-12 Bulan',
        description: [
          'Duduk tanpa bantuan',
          'Merangkak/merayap',
          'Mengucapkan kata sederhana ("mama", "baba")',
          'Mengambil benda kecil dengan jari',
          'Berdiri berpegangan',
          'Merespon saat dipanggil namanya',
        ],
      ),
      _DevData(
        icon: Icons.directions_walk,
        color: Color(0xFFFFF59D),
        title: '12-24 Bulan',
        description: [
          'Berjalan sendiri',
          'Menyusun 2-4 balok',
          'Mengucapkan beberapa kata',
          'Meniru gerakan orang lain',
          'Makan/minum sendiri dengan bantuan',
          'Menunjuk bagian tubuh saat diminta',
        ],
      ),
      _DevData(
        icon: Icons.emoji_nature,
        color: Color(0xFFB39DDB),
        title: '2-5 Tahun',
        description: [
          'Berlari, melompat, memanjat',
          'Menggambar garis/lingkaran',
          'Menggunakan kalimat sederhana',
          'Bermain bersama anak lain',
          'Mengenal warna dan bentuk',
          'Mulai mandiri dalam berpakaian/makan',
        ],
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Perkembangan Anak'),
        backgroundColor: const Color(0xFFFFB6C1),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body:
          devs.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/cute_baby.png',
                      height: 120,
                      errorBuilder:
                          (c, o, s) => Icon(
                            Icons.child_care,
                            size: 60,
                            color: Colors.pink[200],
                          ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Belum ada data perkembangan.',
                      style: TextStyle(
                        color: Color(0xFFD291BC),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: devs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final d = devs[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: d.color.withAlpha((0.18 * 255).toInt()),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: d.color.withAlpha((0.10 * 255).toInt()),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 18,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: d.color.withAlpha(
                                    (0.18 * 255).toInt(),
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Icon(d.icon, color: d.color, size: 32),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  d.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: d.color.darken(0.2),
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...d.description.map(
                                  (desc) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 6),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: d.color.darken(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            desc,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFB266B2),
                                              fontWeight: FontWeight.w500,
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
