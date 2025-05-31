import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class LastPeriodProvider extends ChangeNotifier {
  DateTime? _lastPeriodDate;

  DateTime? get lastPeriodDate => _lastPeriodDate;

  void setLastPeriodDate(DateTime date) {
    _lastPeriodDate = date;
    notifyListeners();
  }
}

class PregnancyDashboardPage extends StatelessWidget {
  const PregnancyDashboardPage({super.key});

  int calculatePregnancyWeeks(DateTime lastPeriod) {
    final now = DateTime.now();
    final diff = now.difference(lastPeriod);
    return (diff.inDays / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    final lastPeriod = context.watch<LastPeriodProvider>().lastPeriodDate;
    final weeks = lastPeriod != null ? calculatePregnancyWeeks(lastPeriod) : 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Kehamilan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Umur Kehamilan',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '$weeks minggu',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              'Tanggal Haid Terakhir: ${lastPeriod != null ? "${lastPeriod.day}-${lastPeriod.month}-${lastPeriod.year}" : "-"}',
            ),
          ],
        ),
      ),
    );
  }
}

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
                          context.read<LastPeriodProvider>().setLastPeriodDate(
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LastPeriodProvider(),
      child: MaterialApp(
        title: 'BukuPink',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFFFFB6C1), // Soft pink
            primary: Color(0xFFFFB6C1), // Pink
            secondary: Color(0xFFFFC1CC), // Light pink
            background: Color(0xFFFFF0F5), // Lavender blush
            onPrimary: Colors.white,
          ),
          scaffoldBackgroundColor: Color(0xFFFFF0F5),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFFFB6C1),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFFFB6C1),
          ),
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              color: Color(0xFFB266B2),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BukuPink - Ibu Hamil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            MenuCard(
              icon: Icons.favorite,
              title: 'Pemantauan Kehamilan',
              color: Color(0xFFFFB6C1),
              onTap: () {
                final lastPeriod =
                    context.read<LastPeriodProvider>().lastPeriodDate;
                if (lastPeriod == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LastPeriodFormPage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PregnancyDashboardPage(),
                    ),
                  );
                }
              },
            ),
            MenuCard(
              icon: Icons.child_friendly,
              title: 'Persiapan Melahirkan',
              color: Color(0xFFFFC1CC),
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.family_restroom,
              title: 'Pasca Melahirkan',
              color: Color(0xFFB266B2),
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.monitor_heart,
              title: 'Pemantauan Tumbuh Kembang Anak',
              color: Color(0xFF81C784), // hijau pastel
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.local_dining,
              title: 'Panduan Menyusui & Nutrisi',
              color: Color(0xFFFFE082), // kuning pastel
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.self_improvement,
              title: 'Kesehatan Mental Ibu',
              color: Color(0xFF9575CD), // ungu pastel
              onTap: () {},
            ),
            MenuCard(
              icon: Icons.group,
              title: 'Keluarga Berencana',
              color: Color(0xFF4FC3F7), // biru pastel
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0.5,
        shadowColor: color.withOpacity(0.15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.18), width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(14),
                child: Icon(icon, color: color.withOpacity(0.85), size: 30),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
