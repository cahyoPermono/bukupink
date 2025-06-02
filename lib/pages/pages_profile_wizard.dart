import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/services_user.dart';

class ProfileWizardPage extends StatefulWidget {
  const ProfileWizardPage({super.key});

  @override
  State<ProfileWizardPage> createState() => _ProfileWizardPageState();
}

class _ProfileWizardPageState extends State<ProfileWizardPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  int _step = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      _animController.reverse().then((_) {
        setState(() {
          _step++;
          _animController.forward();
        });
      });
    }
  }

  void _prevStep() {
    setState(() {
      _animController.reverse().then((_) {
        _step--;
        _animController.forward();
      });
    });
  }

  Future<void> _saveProfile() async {
    final profile = UserProfile(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text),
      height: double.parse(_heightController.text),
      weight: double.parse(_weightController.text),
    );
    await UserProfileService.insertProfile(profile);
    Get.offAllNamed('/home');
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              Text(
                'Nama Lengkap',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: _nextStep, child: const Text('Lanjut')),
            ],
          ),
        );
      case 1:
        return FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              Text('Umur', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Umur (tahun)'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Umur wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _prevStep,
                    child: const Text('Kembali'),
                  ),
                  ElevatedButton(
                    onPressed: _nextStep,
                    child: const Text('Lanjut'),
                  ),
                ],
              ),
            ],
          ),
        );
      case 2:
        return FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              Text(
                'Tinggi Badan',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Tinggi (cm)'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Tinggi wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _prevStep,
                    child: const Text('Kembali'),
                  ),
                  ElevatedButton(
                    onPressed: _nextStep,
                    child: const Text('Lanjut'),
                  ),
                ],
              ),
            ],
          ),
        );
      case 3:
        return FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              Text(
                'Berat Badan',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Berat (kg)'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Berat wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _prevStep,
                    child: const Text('Kembali'),
                  ),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lengkapi Profil')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _buildStepContent(),
              transitionBuilder:
                  (child, anim) => FadeTransition(opacity: anim, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
