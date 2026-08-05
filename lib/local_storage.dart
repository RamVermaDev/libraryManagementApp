import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveLogin({
    required String token,
    required String userJson,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await prefs.setString('user', userJson);
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('isLoggedIn');
    await prefs.remove('currentLibrary');
    await prefs.remove('currentLibraryName');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Current Library

  static Future<void> saveCurrentLibrary({
    required String libraryId,
    String? libraryName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentLibrary', libraryId);
    if (libraryName != null && libraryName.isNotEmpty) {
      await prefs.setString('currentLibraryName', libraryName);
    }
  }

  static Future<String?> getCurrentLibrary() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentLibrary');
  }

  static Future<String?> getCurrentLibraryName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentLibraryName');
  }

  // App Mode Storage

  static Future<void> saveAppMode(String modeKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_app_mode', modeKey);
  }

  static Future<String?> getAppMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('active_app_mode');
  }
}
