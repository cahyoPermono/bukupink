import 'package:bukupink/pages/pages_child_growth.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Daftar Anak'),
        backgroundColor: const Color(0xFFFFB6C1),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddChildDialog,
          ),
        ],
      ),
      body:
          _children.isEmpty
              ? const Center(child: Text('Belum ada data anak.'))
              : ListView.builder(
                itemCount: _children.length,
                itemBuilder: (context, i) {
                  final c = _children[i];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        c['jenis_kelamin'] == 'L' ? Icons.boy : Icons.girl,
                        color: Colors.pink[300],
                      ),
                      title: Text(c['nama']),
                      subtitle: Text('Lahir: ${c['tanggal_lahir']}'),
                      onTap: () => _openChildMenu(c),
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
      Navigator.pop(context);
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
