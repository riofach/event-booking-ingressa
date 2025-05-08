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

  /// Factory constructor untuk membuat UserEntity dari Map
  /// Berguna untuk konversi dari shared preferences
  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }
}
