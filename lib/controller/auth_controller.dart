import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _userKey = "user_data";

  /// Salvar response no SharedPreferences
  static Future<void> saveUserData(Map<String, dynamic> response) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(response); // transforma em string
    await prefs.setString(_userKey, jsonString);
  }

  /// Recuperar response do SharedPreferences
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_userKey);

    if (jsonString != null) {
      return jsonDecode(jsonString); // volta para Map
    }
    return null;
  }

  /// Excluir response salvo
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
