import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';
import 'pages_dashboard.dart';
import 'services_pregnancy.dart';

class LastPeriodFormPage extends StatefulWidget {
  const LastPeriodFormPage({super.key});

  @override
  State<LastPeriodFormPage> createState() => _LastPeriodFormPageState();
}

class _LastPeriodFormPageState extends State<LastPeriodFormPage> {
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Tanggal Haid Terakhir')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tambahkan input nama kehamilan
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kehamilan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kehamilan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Masukkan tanggal haid terakhir Anda',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 2),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.pinkAccent.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.pink[300]),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Pilih tanggal'
                            : '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed:
                    (_selectedDate == null)
                        ? null
                        : () async {
                          if (_formKey.currentState!.validate()) {
                            final name = _nameController.text.trim();
                            final date = _selectedDate!;
                            final dateString =
                                '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                            await PregnancyService.insertPregnancy(
                              Pregnancy(name: name, date: dateString),
                            );
                            Get.find<LastPeriodController>().setLastPeriodDate(
                              _selectedDate!,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PregnancyDashboardPage(),
                              ),
                            );
                          }
                        },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
