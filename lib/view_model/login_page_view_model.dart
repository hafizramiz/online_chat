import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/create_muser_object.dart';
import '../model/m_user.dart';
import '../services/auth_service.dart';
import '../services/shared_pref_service.dart';


class LoginPageViewModel with ChangeNotifier{
  bool _isLoading=false;

  bool get getisLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AuthService _authService = AuthService.authService;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<MUser> signInWithEmailAndPassword() async {
    late MUser loggedUser;
    try {
      User? user = await _authService.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (user != null) {
        loggedUser = CreateMUser.createMUserObject(
            AuthState.SUCCESFULL, user.uid, user.email);
        // Burda kullanici giris yapabildiyse onun token bilgisini alip kayit atcam
        await CacheManager.token.write(user.uid);
      } else {
        loggedUser = CreateMUser.createMUserObject(AuthState.ERROR, null);
      }


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        loggedUser =
            CreateMUser.createMUserObject(AuthState.USERNOTFOUND, null);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        loggedUser =
            CreateMUser.createMUserObject(AuthState.WRONGPASSWORD, null);
      } else {
        loggedUser = CreateMUser.createMUserObject(AuthState.ERROR, null);
      }
    } catch (error) {
      loggedUser = CreateMUser.createMUserObject(AuthState.ERROR, null);
    }
    return loggedUser;
  }



}
