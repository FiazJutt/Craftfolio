import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref('UsersData');

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Save user data to Realtime Database
      if (userCredential.user != null) {
        await saveUserData(userCredential.user!.uid, {
          'name': name,
          'email': email,
          'password':
              password, // Note: Storing password in plaintext is not recommended for security reasons
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  // Save user data to Realtime Database
  Future<void> saveUserData(
      String userId, Map<String, dynamic> userData) async {
    try {
      await _database.child('userAuthData').child(userId).set(userData);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'email-already-in-use':
        message = 'This email is already in use by another account.';
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      case 'weak-password':
        message = 'The password is too weak.';
        break;
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided for that user.';
        break;
      case 'user-disabled':
        message = 'This user has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many requests. Try again later.';
        break;
      case 'operation-not-allowed':
        message = 'Operation not allowed.';
        break;
      default:
        message = 'An unknown error occurred: ${e.message}';
    }

    return Exception(message);
  }
}
