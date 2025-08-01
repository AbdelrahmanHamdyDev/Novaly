import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
String _collectionName = 'bookmarks';

class Firebase_Auth {
  Future<String?> register_With_Email_And_Password(
    String emailAddress,
    String password,
    String userName,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
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

  Future<String?> Login_With_Email_And_Password(
    String emailAddress,
    String password,
  ) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
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

  Future<bool> Login_With_Google() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await firebaseAuth.signInWithCredential(
          credential,
        );
        return userCredential.user != null;
      }
      return false;
    } catch (error) {
      print("Error in Google login: $error");
      return false;
    }
  }

  SignOut() {
    firebaseAuth.signOut();
  }

  String _handleAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return "Invalid email";
      case 'weak-password':
        return "Weak password";
      case 'email-already-in-use':
        return "Email already in use";
      case 'network-request-failed':
        return "Network request failed";
      case 'user-not-found':
        return "User not found";
      case 'wrong-password' ||
          'INVALID_LOGIN_CREDENTIALS' ||
          'invalid-credential':
        return "Wrong Email or password";

      default:
        return "failed";
    }
  }
}

class Firebase_Store {
  CollectionReference table = firestore.collection(_collectionName);
  addNewUser(String data) {
    table
        .doc(firebaseAuth.currentUser!.uid)
        .set({'Data': data})
        .catchError((error) => print("Failed to add Data: $error"));
  }

  Future<List<Map<String, dynamic>>> getUserData() async {
    try {
      DocumentSnapshot data =
          await table.doc(firebaseAuth.currentUser!.uid).get();
      var jsonString = (data.data() as Map<String, dynamic>)['Data'];

      return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    } catch (error) {
      return [];
    }
  }
}
