import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
String _collectionName = 'bookmarks';

class Firebase_Auth {
  Future<String?> registerUser(
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

  Future<String?> signInUser(String emailAddress, String password) async {
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
