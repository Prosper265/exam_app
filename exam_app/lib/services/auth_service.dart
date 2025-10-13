import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Customize email
  String mapRegNumberToEmail(String regNumber) {
    return '$regNumber@must.ac.mw';
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with custom email and phone number as password 
  Future<String?> signIn(String regNumber, String phone) async {
    String finalEmail = mapRegNumberToEmail(regNumber);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: finalEmail,
        password: phone,
      );

      if (userCredential.user != null) {
        print('Login successful: ${userCredential.user!.uid}');
        return null; // Success - no error
      }
      return 'Login failed';
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors
      if (e.code == 'user-not-found') {
        return 'Registration number not found';
      } else if (e.code == 'wrong-password') {
        return 'Invalid phone number';
      } else if (e.code == 'invalid-email') {
        return 'Invalid registration number format';
      } else if (e.code == 'too-many-requests') {
        return 'Too many attempts. Try again later.';
      }
      return e.message ?? 'An error occurred during login';
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }

  // signup with custom email and phone number as password
Future<String?> signUp(String regNumber, String phone) async {
  String finalEmail = mapRegNumberToEmail(regNumber);
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: finalEmail,
      password: phone,
    );

    if (userCredential.user != null) {
      print('Sign up successful: ${userCredential.user!.uid}');
      return null; // Success - no error
    }
    return 'Sign up failed';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'Phone number is too weak';
    } else if (e.code == 'email-already-in-use') {
      return 'Registration number already exists';
    } else if (e.code == 'invalid-email') {
      return 'Invalid registration number format';
    }
    return e.message ?? 'An error occurred during sign up';
  } catch (e) {
    return 'An unexpected error occurred';
  }
}

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}