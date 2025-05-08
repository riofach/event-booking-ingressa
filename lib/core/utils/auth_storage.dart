import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Utility class untuk menyimpan dan mengambil data autentikasi
/// dari SharedPreferences untuk fitur Remember Me
class AuthStorage {
  // Keys untuk SharedPreferences
  static const String _keyIsRemembered = 'is_remembered';
  static const String _keyEmail = 'remembered_email';
  static const String _keyUserData = 'user_data';

  /// Menyimpan data user jika remember me dicentang
  static Future<void> saveUserCredentials({
    required String email,
    required bool isRemembered,
    required Map<String, dynamic>? userData,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan status remember me
    await prefs.setBool(_keyIsRemembered, isRemembered);

    if (isRemembered) {
      // Simpan email untuk auto-fill
      await prefs.setString(_keyEmail, email);

      // Simpan data user jika ada (opsional)
      if (userData != null) {
        await prefs.setString(_keyUserData, jsonEncode(userData));
      }
    } else {
      // Jika tidak remember me, hapus data sebelumnya
      await clearUserCredentials(keepRememberMeStatus: true);
    }
  }

  /// Mengambil email yang tersimpan untuk auto-fill
  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final isRemembered = prefs.getBool(_keyIsRemembered) ?? false;

    if (isRemembered) {
      return prefs.getString(_keyEmail);
    }
    return null;
  }

  /// Mengambil data user yang tersimpan (untuk auto login)
  static Future<Map<String, dynamic>?> getSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final isRemembered = prefs.getBool(_keyIsRemembered) ?? false;

    if (isRemembered) {
      final userDataStr = prefs.getString(_keyUserData);
      if (userDataStr != null && userDataStr.isNotEmpty) {
        return jsonDecode(userDataStr) as Map<String, dynamic>;
      }
    }
    return null;
  }

  /// Cek apakah fitur remember me aktif
  static Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsRemembered) ?? false;
  }

  /// Menghapus semua data kredensial yang tersimpan
  static Future<void> clearUserCredentials({
    bool keepRememberMeStatus = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Jika perlu, simpan status remember me
    final rememberMeStatus =
        keepRememberMeStatus ? await isRememberMeEnabled() : false;

    // Hapus data kredensial
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyUserData);

    // Atur ulang status remember me
    if (keepRememberMeStatus) {
      await prefs.setBool(_keyIsRemembered, rememberMeStatus);
    } else {
      await prefs.remove(_keyIsRemembered);
    }
  }
}
