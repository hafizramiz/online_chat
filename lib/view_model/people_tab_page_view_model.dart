import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/create_muser_object.dart';
import '../model/m_user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class PeopleTabPageViewModel{
  AuthService _authService = AuthService.authService;
  FirestoreService _firestoreService = FirestoreService.firestoreService;

  MUser getCurrentUser() {
    MUser currentUser;
    try {
      User? user = _authService.currentUser();
      if (user != null) {
        currentUser = CreateMUser.createMUserObject(
            AuthState.SUCCESFULL, user.uid, user.email);
      } else {
        currentUser =
            CreateMUser.createMUserObject(AuthState.ERROR, null, null);
      }
    } catch (error) {
      print("hata: $error");
      currentUser = CreateMUser.createMUserObject(AuthState.ERROR, null, null);
    }
    return currentUser;
  }

  Stream<QuerySnapshot> getAllUsers() {
    final Stream<QuerySnapshot> _usersStream = _firestoreService.getAllUsers();
    return _usersStream;
  }
  Future<bool> signOut() async {
    try {
      print("cikis basladi");
      await _authService.signOut();
      return true;
    } catch (error) {
      return false;
    }
  }
}