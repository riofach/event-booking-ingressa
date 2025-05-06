/// Entity User sesuai dengan data model Firestore dan kebutuhan aplikasi.
class UserEntity {
  /// ID unik user (Firestore UID)
  final String id;

  /// Nama user
  final String name;

  /// Email user
  final String email;

  /// Role user (user, organizer, admin)
  final String role;

  /// Tanggal pembuatan akun
  final DateTime? createdAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.createdAt,
  });
}
