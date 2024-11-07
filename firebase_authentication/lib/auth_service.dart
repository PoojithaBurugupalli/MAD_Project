import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Successfully registered: ${userCredential.user?.email}";
    } on FirebaseAuthException catch (e) {
      // Catching specific error codes
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is badly formatted.';
      } else {
        return 'An unexpected error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An error occurred during registration. Please try again.';
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Successfully signed in as ${userCredential.user?.email}";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is badly formatted.';
      } else {
        return 'An unexpected error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An error occurred during sign-in. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> changePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
      return "Password updated successfully";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else {
        return 'An error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An error occurred while updating the password.';
    }
  }

  User? get currentUser => _auth.currentUser;
}
