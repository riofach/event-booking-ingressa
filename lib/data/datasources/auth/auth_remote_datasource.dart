import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/user_entity.dart';

/// Datasource untuk autentikasi user menggunakan Firebase Auth.
class AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDatasource({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Login dengan email dan password
  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  /// Register user baru dengan email dan password
  Future<User?> registerWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  /// Sign out user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  /// Login dengan Google
  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user != null) {
      // Cek dan insert user ke Firestore jika belum ada
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (!userDoc.exists) {
        await createUserInFirestore(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          role: 'user',
        );
      }
    }
    return user;
  }

  /// Mendapatkan user yang sedang login
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Menyimpan data user baru ke Firestore setelah register
  Future<void> createUserInFirestore({
    required String uid,
    required String name,
    required String email,
    String role = 'user',
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'id': uid,
      'name': name,
      'email': email,
      'role': role,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  /// Mengambil data user lengkap dari Firestore berdasarkan UID
  Future<UserEntity?> getUserFromFirestore(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return UserEntity(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      createdAt:
          (data['created_at'] is Timestamp)
              ? (data['created_at'] as Timestamp).toDate()
              : null,
    );
  }

  /// Mengirim email reset password ke user
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
