import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService._internal();

  static final AuthService _authService = AuthService._internal();

  factory AuthService() => _authService;

  static AuthService get authService => _authService;

  Stream<User?> authStateChanges() {
    Stream<User?> authStream = _auth.authStateChanges();
    return authStream;
  }

  Future<User?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential createdUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
    );
    print("Olusturulan User: ${createdUser.user}");
    return createdUser.user;
  }


  Future<void> signOut() async {
     print("Cikis yapiliyor");
     await _auth.signOut();
    // GoogleSignIn _googleSignIn=GoogleSignIn();
     // _googleSignIn!=null?_googleSignIn.signOut():debugPrint("google sign in durumu: ${_googleSignIn.currentUser}");
  }

  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    print(userCredential.user);
    return userCredential.user;
  }

  User? currentUser() {
    final user = _auth.currentUser;
    print("Current user email : ${user?.email}");
    print("current user userId: ${user?.uid}");
    return user;
  }


  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
     UserCredential userCredential=await _auth.signInWithCredential(credential);
     return userCredential.user;
  }

  Future<void> deleteUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.delete();
      } catch (error) {
       print(error);
      }
    }
  }

}
