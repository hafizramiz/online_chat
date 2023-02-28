import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/services/auth_service.dart';
import '../helpers/create_muser_object.dart';
import '../model/m_user.dart';
import '../services/firestore_service.dart';

class SignUpPageViewModel with ChangeNotifier{
  bool _isLoading=false;

  bool get getisLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AuthService _authService = AuthService.authService;
  FirestoreService _firestoreService = FirestoreService.firestoreService;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController againPasswordController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();

  Future<MUser> createAndSaveUserWithEmailAndPassword() async {
    late MUser createdUser;
    try {
     isLoading=true;
      User? user = await _authService.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (user != null) {
        print("display name: ${displayNameController.text}");
        createdUser = CreateMUser.createMUserObject(AuthState.SUCCESFULL,
            user.uid, user.email, displayNameController.text);
        print("User uid: ${user.uid}");
        createdUser.userId != null
            ? await _firestoreService.addUserToFirestore(createdUser)
            : print("user id null clod'a kayit yapamadim");
      } else {
        createdUser = CreateMUser.createMUserObject(AuthState.ERROR, null);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        createdUser =
            CreateMUser.createMUserObject(AuthState.WEAKPASSWORD, null);
      } else if (e.code == 'email-already-in-use') {
        print("e mail in use calisti");
        createdUser = CreateMUser.createMUserObject(AuthState.EMAILINUSE, null);
      } else {
        createdUser = CreateMUser.createMUserObject(AuthState.ERROR, null);
      }
    } catch (error) {
      createdUser = CreateMUser.createMUserObject(AuthState.ERROR, null);
    }
    return createdUser;
  }
  Future<MUser> signInWithGoogle() async {
    MUser createdGoogleUser;
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        createdGoogleUser = CreateMUser.createMUserObject(
          //,user.displayName, user.metadata.creationTime,user.photoURL
            AuthState.SUCCESFULL,
            user.uid,
            user.email,
            user.displayName,
            user.photoURL);
        createdGoogleUser.userId != null
            ? await _firestoreService.addUserToFirestore(createdGoogleUser)
            : print("user id null clod'a kayit yapamadim");
      } else {
        createdGoogleUser =
            CreateMUser.createMUserObject(AuthState.ERROR, null);
      }
    } catch (error) {
      createdGoogleUser = CreateMUser.createMUserObject(AuthState.ERROR, null);
      print("google giriste hata: ${error}");
    }
    return createdGoogleUser;
  }

}