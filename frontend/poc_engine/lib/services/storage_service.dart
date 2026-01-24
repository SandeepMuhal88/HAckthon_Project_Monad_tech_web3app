import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String userAddressKey = 'user_address';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String isLoggedInKey = 'is_logged_in';

  static Future<void> saveUserAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userAddressKey, address);
  }

  static Future<String?> getUserAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userAddressKey);
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userEmailKey, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
