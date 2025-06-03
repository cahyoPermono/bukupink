import 'package:flutter/material.dart';
import '../services/db.dart';

class ChildGrowthPage extends StatelessWidget {
  final Map<String, dynamic> child;
  const ChildGrowthPage({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pemantauan: ${child['nama']}'),
        backgroundColor: const Color(0xFFFFB6C1),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
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
          const SizedBox(height: 24),
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
          const SizedBox(height: 24),
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.pink[300], size: 36),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
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
  final _formKey = GlobalKey<FormState>();
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

  void _addEntry() async {
    if (_formKey.currentState!.validate()) {
      final db = await DB.database;
      await db.insert('growth', {
        'anak_id': widget.childId,
        'tanggal': _dateController.text,
        'berat': double.parse(_weightController.text),
        'tinggi': double.parse(_heightController.text),
      });
      _dateController.clear();
      _weightController.clear();
      _heightController.clear();
      _loadGrowth();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Berat Badan / Tinggi'),
        backgroundColor: const Color(0xFFFFB6C1),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Tabel'), Tab(text: 'Grafik')],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal',
                        hintText: 'YYYY-MM-DD',
                        icon: Icon(Icons.calendar_today),
                      ),
                      validator:
                          (v) => v == null || v.isEmpty ? 'Isi tanggal' : null,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _dateController.text =
                              '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: 'Berat (kg)',
                        icon: Icon(Icons.monitor_weight),
                      ),
                      keyboardType: TextInputType.number,
                      validator:
                          (v) => v == null || v.isEmpty ? 'Isi berat' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      decoration: const InputDecoration(
                        labelText: 'Tinggi (cm)',
                        icon: Icon(Icons.height),
                      ),
                      keyboardType: TextInputType.number,
                      validator:
                          (v) => v == null || v.isEmpty ? 'Isi tinggi' : null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color(0xFF81C784),
                    ),
                    onPressed: _addEntry,
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
                      ? const Center(child: Text('Belum ada data.'))
                      : ListView(
                        children: [
                          DataTable(
                            columns: const [
                              DataColumn(label: Text('Tanggal')),
                              DataColumn(label: Text('Berat')),
                              DataColumn(label: Text('Tinggi')),
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
                  ListView(
                    children: [
                      SizedBox(
                        height: 180,
                        child: _SimpleLineChart(
                          entries: _entries,
                          isWeight: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: _SimpleLineChart(
                          entries: _entries,
                          isWeight: false,
                        ),
                      ),
                    ],
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
    final points =
        entries
            .asMap()
            .entries
            .map(
              (e) => Offset(
                e.key * 40.0 + 10,
                160 - ((isWeight ? e.value.weight : e.value.height) * 4),
              ),
            )
            .toList();
    return CustomPaint(
      painter: _LineChartPainter(points: points, isWeight: isWeight),
      child: Container(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<Offset> points;
  final bool isWeight;
  _LineChartPainter({required this.points, required this.isWeight});

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
    for (final p in points) {
      canvas.drawCircle(p, 4, Paint()..color = paint.color);
    }
    final textPainter = TextPainter(
      text: TextSpan(
        text: isWeight ? 'Grafik Berat Badan' : 'Grafik Tinggi Badan',
        style: const TextStyle(fontSize: 13, color: Colors.black54),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(0, 0));
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

  @override
  void initState() {
    super.initState();
    _loadImunisasi();
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Imunisasi'),
        backgroundColor: const Color(0xFFFFB6C1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tambah Imunisasi',
                      prefixIcon: Icon(Icons.add),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF81C784),
                  ),
                  onPressed: _addImmunization,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child:
                  _immunizations.isEmpty
                      ? const Center(child: Text('Belum ada jadwal imunisasi.'))
                      : ListView.builder(
                        itemCount: _immunizations.length,
                        itemBuilder: (context, i) {
                          final item = _immunizations[i];
                          return Card(
                            child: ListTile(
                              leading: Checkbox(
                                value: item.done,
                                onChanged: (val) {
                                  setState(() {
                                    item.done = val ?? false;
                                  });
                                },
                              ),
                              title: Text(item.name),
                              subtitle:
                                  item.date.isNotEmpty
                                      ? Text('Tanggal: ${item.date}')
                                      : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.event,
                                      color: Color(0xFFFFB6C1),
                                    ),
                                    tooltip: 'Pilih tanggal',
                                    onPressed: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime.now().add(
                                          const Duration(days: 365),
                                        ),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          item.date =
                                              '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                                        });
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    tooltip: 'Hapus',
                                    onPressed: () => _removeImmunization(i),
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

class ChildDevelopmentPage extends StatelessWidget {
  const ChildDevelopmentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perkembangan Anak'),
        backgroundColor: const Color(0xFFFFB6C1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _DevelopmentTile(
            title: '0-6 Bulan',
            description: '''
- Mengangkat kepala saat tengkurap
- Mulai tersenyum sosial
- Menggenggam benda
- Mengeluarkan suara (cooing)
- Mengikuti benda dengan mata
- Mulai membalikkan badan
''',
          ),
          _DevelopmentTile(
            title: '6-12 Bulan',
            description: '''
- Duduk tanpa bantuan
- Merangkak/merayap
- Mengucapkan kata sederhana ("mama", "baba")
- Mengambil benda kecil dengan jari
- Berdiri berpegangan
- Merespon saat dipanggil namanya
''',
          ),
          _DevelopmentTile(
            title: '12-24 Bulan',
            description: '''
- Berjalan sendiri
- Menyusun 2-4 balok
- Mengucapkan beberapa kata
- Meniru gerakan orang lain
- Makan/minum sendiri dengan bantuan
- Menunjuk bagian tubuh saat diminta
''',
          ),
          _DevelopmentTile(
            title: '2-5 Tahun',
            description: '''
- Berlari, melompat, memanjat
- Menggambar garis/lingkaran
- Menggunakan kalimat sederhana
- Bermain bersama anak lain
- Mengenal warna dan bentuk
- Mulai mandiri dalam berpakaian/makan
''',
          ),
        ],
      ),
    );
  }
}

class _DevelopmentTile extends StatelessWidget {
  final String title;
  final String description;
  const _DevelopmentTile({required this.title, required this.description});
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(padding: const EdgeInsets.all(12.0), child: Text(description)),
      ],
    );
  }
}
