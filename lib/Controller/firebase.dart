import 'package:firebase_auth/firebase_auth.dart';

class fireBase {
  FirebaseAuth fireBaseData = FirebaseAuth.instance;

  Future<String?> registerUser(
    String emailAddress,
    String password,
    String userName,
  ) async {
    try {
      UserCredential userCredential = await fireBaseData
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );

      await userCredential.user!.updateDisplayName(userName);
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    } catch (e) {
      return "Registration failed";
    }
  }

  Future<String?> signInUser(String emailAddress, String password) async {
    try {
      await fireBaseData.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    } catch (e) {
      return "Sign-in failed";
    }
  }

  String _handleAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return "Invalid email";
      case 'network-request-failed':
        return "Network request failed";
      case 'user-not-found':
        return "User not found";
      case 'wrong-password':
        return "Wrong password";
      case 'weak-password':
        return "Weak password";
      case 'email-already-in-use':
        return "Email already in use";
      default:
        return "Authentication failed";
    }
  }
}
