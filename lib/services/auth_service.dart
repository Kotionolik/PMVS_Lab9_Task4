import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const _emailKey = 'auth_email';
  static const _tokenKey = 'auth_token';
  Future<AppUser?> login(String email, String password) async {
    try {
      if (email.isEmpty || password.length < 4) return null;
      final token = 'tok_' + DateTime.now().millisecondsSinceEpoch.toString();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, email);
      await prefs.setString(_tokenKey, token);
      return AppUser(email: email, token: token);
    } catch (e, s) {
      print('AuthService.login: $e\n$s');
      return null;
    }
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_tokenKey);
  }
  Future<AppUser?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final e = prefs.getString(_emailKey);
    final t = prefs.getString(_tokenKey);
    if (e == null || t == null) return null;
    return AppUser(email: e, token: t);
  }
  Future<bool> isLoggedIn() async => (await currentUser()) != null;
}