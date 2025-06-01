import 'package:get/get.dart';
import 'services_user.dart';

class AuthService {
  static Future<bool> login(String username, String password) async {
    final user = await DatabaseService.getUser(username, password);
    await Future.delayed(Duration(milliseconds: 500));
    return user != null;
  }

  static void logout() {
    Get.offAllNamed('/login');
  }
}
