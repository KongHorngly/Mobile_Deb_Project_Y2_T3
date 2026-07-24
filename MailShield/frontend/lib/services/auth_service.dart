import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

/// Wraps Firebase Auth for CyberMail's login/register/guest/change-password
/// flows. Pairs with FirestoreService to load the user's profile/stats.
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth, FirestoreService? firestoreService})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestoreService = firestoreService ?? FirestoreService();

  final FirebaseAuth _firebaseAuth;
  final FirestoreService _firestoreService;

  User? get currentFirebaseUser => _firebaseAuth.currentUser;
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    // NOTE: Firebase Auth authenticates by email, not username.
    // If your backend keys accounts by username, resolve it to an
    // email first via FirestoreService before calling signInWithEmail.
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: username,
      password: password,
    );

    final uid = credential.user!.uid;
    return _firestoreService.getUser(uid);
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = UserModel(
      id: credential.user!.uid,
      username: username,
      email: email,
    );

    await _firestoreService.createUser(user);
    return user;
  }

  Future<void> changePassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('No user is currently signed in.');
    }
    await user.updatePassword(newPassword);
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}
