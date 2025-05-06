/// Utility untuk mapping error Firebase Auth ke pesan user-friendly (Bahasa Indonesia)
String mapFirebaseAuthError(String message) {
  if (message.contains('email-already-in-use')) {
    return 'Email sudah terdaftar, silakan login atau gunakan email lain.';
  }
  if (message.contains('wrong-password')) {
    return 'Password salah, silakan coba lagi.';
  }
  if (message.contains('user-not-found')) {
    return 'Akun dengan email ini tidak ditemukan.';
  }
  if (message.contains('invalid-email')) {
    return 'Format email tidak valid.';
  }
  if (message.contains('weak-password')) {
    return 'Password terlalu lemah, gunakan minimal 6 karakter.';
  }
  if (message.contains('network-request-failed')) {
    return 'Koneksi internet bermasalah, silakan cek jaringan Anda.';
  }
  // Tambahkan mapping lain sesuai kebutuhan
  return 'Terjadi kesalahan. Silakan coba lagi.';
}
