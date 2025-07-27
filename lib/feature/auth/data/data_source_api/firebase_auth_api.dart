import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthApi {
  final FirebaseAuth auth;


  FirebaseAuthApi({required this.auth,});

  Future<void> signUp(String email, String password) async {
    try {
      var users = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await users.user?.sendEmailVerification();
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  Future<bool> isSignedIn() async {
    try {
      User? user = auth.currentUser;
      if (user != null ) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to check sign-in status: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      User? user = auth.currentUser;
      await user?.reload();
      return user?.emailVerified ?? false;
    } catch (e) {
      throw Exception('Failed to check email verification: $e');
    }
  }

  Future<void> resendEmailVerification() async {
    try {
      User? user = auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else {
        throw Exception('User is not signed in or email is already verified');
      }
    } catch (e) {
      throw Exception('Failed to resend email verification: $e');
    }
  }

  }
