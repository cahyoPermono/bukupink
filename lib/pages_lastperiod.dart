import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';
import 'pages_dashboard.dart';

class LastPeriodFormPage extends StatefulWidget {
  const LastPeriodFormPage({super.key});

  @override
  State<LastPeriodFormPage> createState() => _LastPeriodFormPageState();
}

class _LastPeriodFormPageState extends State<LastPeriodFormPage> {
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

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
                    _selectedDate == null
                        ? null
                        : () {
                          Get.find<LastPeriodController>().setLastPeriodDate(
                            _selectedDate!,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PregnancyDashboardPage(),
                            ),
                          );
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
