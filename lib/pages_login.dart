import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services.dart';

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
      Get.offAllNamed('/home');
    } else {
      _error.value = 'Username atau password salah';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BukuPink',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
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
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
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
                      child:
                          _loading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Login'),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Get.offAllNamed('/signup'),
                  child: const Text('Belum punya akun? Daftar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
