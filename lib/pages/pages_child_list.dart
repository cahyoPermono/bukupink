import 'package:bukupink/pages/pages_child_growth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/db.dart';

class ChildListPage extends StatefulWidget {
  const ChildListPage({super.key});
  @override
  State<ChildListPage> createState() => _ChildListPageState();
}

class _ChildListPageState extends State<ChildListPage> {
  List<Map<String, dynamic>> _children = [];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final db = await DB.database;
    final data = await db.query('anak', orderBy: 'nama');
    setState(() => _children = data);
  }

  void _showAddChildDialog() {
    showDialog(
      context: context,
      builder: (context) => AddChildDialog(onSaved: _loadChildren),
    );
  }

  void _openChildMenu(Map<String, dynamic> child) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChildGrowthPage(child: child)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      appBar: AppBar(
        title: const Text('Daftar Anak'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC1CC),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFB266B2)),
            tooltip: 'Tambah Anak',
            onPressed: _showAddChildDialog,
          ),
        ],
      ),
      body:
          _children.isEmpty
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
                            size: 80,
                            color: Colors.pink[200],
                          ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Belum ada data anak',
                      style: TextStyle(
                        color: Color(0xFFD291BC),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Yuk, tambahkan data anak! 👶',
                      style: TextStyle(color: Color(0xFFB266B2), fontSize: 15),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 18,
                ),
                itemCount: _children.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final c = _children[i];
                  return GestureDetector(
                    onTap: () => _openChildMenu(c),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withValues(alpha: 0.07),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  c['jenis_kelamin'] == 'L'
                                      ? Colors.blue[50]
                                      : Colors.pink[50],
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(18),
                            child: Icon(
                              c['jenis_kelamin'] == 'L'
                                  ? Icons.boy
                                  : Icons.girl,
                              size: 38,
                              color:
                                  c['jenis_kelamin'] == 'L'
                                      ? Colors.blue[300]
                                      : Colors.pink[200],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['nama'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFFB266B2),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.cake_rounded,
                                        color: Color(0xFFFFB6C1),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Lahir: ${c['tanggal_lahir']}',
                                        style: const TextStyle(
                                          color: Color(0xFFB266B2),
                                          fontSize: 14.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 18),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFFD291BC),
                              size: 28,
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

class AddChildDialog extends StatefulWidget {
  final VoidCallback onSaved;
  const AddChildDialog({required this.onSaved, super.key});
  @override
  State<AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<AddChildDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  String _gender = 'L';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate() && _birthDate != null) {
      final db = await DB.database;
      await db.insert('anak', {
        'nama': _nameController.text.trim(),
        'tanggal_lahir':
            '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}',
        'jenis_kelamin': _gender,
      });
      widget.onSaved();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Anak'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Anak'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Tanggal Lahir: '),
                Text(
                  _birthDate == null
                      ? '-'
                      : '${_birthDate!.day.toString().padLeft(2, '0')}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.year}',
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2010),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _birthDate = picked);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Jenis Kelamin: '),
                DropdownButton<String>(
                  value: _gender,
                  items: const [
                    DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                    DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                  ],
                  onChanged: (v) => setState(() => _gender = v!),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Simpan')),
      ],
    );
  }
}
