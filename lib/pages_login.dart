import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services.dart';
import 'services_user.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final RxBool _loading = false.obs;
  final RxString _error = ''.obs;

  Future<void> _login() async {
    _loading.value = true;
    _error.value = '';
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final success = await AuthService.login(username, password);
    _loading.value = false;
    if (success) {
      // Cek profile di database
      final userId = await AuthService.getCurrentUserId(username);
      final profile = await UserProfileService.getProfile();
      if (profile == null) {
        // Jika belum ada profile, arahkan ke wizard profile
        Get.offAllNamed('/profile-wizard', arguments: {'userId': userId});
      } else {
        Get.offAllNamed('/home');
      }
    } else {
      _error.value = 'Username atau password salah';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cute illustration/icon
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Icon(
                  Icons.pregnant_woman,
                  size: 56,
                  color: Colors.pink[200],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'BukuPink',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: const Color(0xFFD291BC),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.07),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.pink[200],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true,
                          fillColor: Colors.pink[50],
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Username wajib diisi'
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: Colors.pink[200]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true,
                          fillColor: Colors.pink[50],
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Password wajib diisi'
                                    : null,
                      ),
                      Obx(
                        () =>
                            _error.value.isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    _error.value,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                )
                                : const SizedBox(),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed:
                                _loading.value
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        _login();
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB6C1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child:
                                _loading.value
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.offAllNamed('/signup'),
                        child: const Text('Belum punya akun? Daftar'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.pink[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
