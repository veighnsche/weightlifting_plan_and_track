import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._privateConstructor();

  static final AuthService _instance = AuthService._privateConstructor();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory AuthService() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String?>? get token {
    return _auth.currentUser?.getIdToken();
  }

  bool get isSignedIn {
    return _auth.currentUser != null;
  }

  Stream<User?> get authStateChanges {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // Listen for metadata changes to force a token refresh
        _firestore.collection('metadata').doc(user.uid).snapshots().listen((snapshot) {
          if (snapshot.exists && snapshot.data() != null && snapshot.data()!['refreshTime'] != null) {
            user.getIdToken(true); // Force refresh the token
          }
        });
      }
    });
    return _auth.authStateChanges();
  }

  User get currentUser {
    return _auth.currentUser!;
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          await user.getIdToken(true);
        }
        return user;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
