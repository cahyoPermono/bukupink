import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services_user.dart';

class AuthService {
  static String? _currentUsername;

  static Future<bool> login(String username, String password) async {
    final user = await DatabaseService.getUser(username, password);
    await Future.delayed(Duration(milliseconds: 500));
    if (user != null) {
      _currentUsername = username;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUser', username);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    _currentUsername = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');
    Get.offAllNamed('/login');
  }

  static Future<int?> getCurrentUserId([String? username]) async {
    final user = await DatabaseService.getUserByUsername(
      username ?? _currentUsername ?? '',
    );
    return user?.id;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('loggedInUser');
    _currentUsername = user;
    return user != null;
  }
}
