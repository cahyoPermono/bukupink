import 'package:flutter/material.dart';
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
                    color: Colors.pinkAccent.withOpacity(0.08),
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

  void _showAddEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final _formKeyDialog = GlobalKey<FormState>();
        final _dateControllerDialog = TextEditingController();
        final _weightControllerDialog = TextEditingController();
        final _heightControllerDialog = TextEditingController();
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
              key: _formKeyDialog,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _dateControllerDialog,
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
                        _dateControllerDialog.text =
                            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                      }
                    },
                    validator:
                        (v) => v == null || v.isEmpty ? 'Isi tanggal' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _weightControllerDialog,
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
                    controller: _heightControllerDialog,
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
                if (_formKeyDialog.currentState!.validate()) {
                  final db = await DB.database;
                  await db.insert('growth', {
                    'anak_id': widget.childId,
                    'tanggal': _dateControllerDialog.text,
                    'berat': double.parse(_weightControllerDialog.text),
                    'tinggi': double.parse(_heightControllerDialog.text),
                  });
                  Navigator.pop(ctx);
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Tabel'), Tab(text: 'Grafik')],
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
                    color: Colors.pinkAccent.withValues(alpha: 0.08),
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
                            headingRowColor: MaterialStateProperty.all(
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
                                color: Colors.pinkAccent.withOpacity(0.07),
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
                                color: Colors.pinkAccent.withOpacity(0.07),
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
                    color: Colors.pinkAccent.withOpacity(0.07),
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
                          color: Colors.greenAccent.withOpacity(0.15),
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
                                  color: Colors.pinkAccent.withOpacity(0.07),
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
                                              Icons.event,
                                              size: 16,
                                              color: Color(0xFFD291BC),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Tanggal: ${item.date}',
                                              style: const TextStyle(
                                                color: Color(0xFFD291BC),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
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
                                        Icons.event,
                                        color: Color(0xFFD291BC),
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
                                          final date =
                                              '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                                          _setDate(i, date);
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
                      color: d.color.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: d.color.withOpacity(0.10),
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
                                  color: d.color.withOpacity(0.18),
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
