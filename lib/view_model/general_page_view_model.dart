import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/create_muser_object.dart';
import '../model/m_user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class GeneralPageViewModel{
  AuthService _authService = AuthService.authService;
  FirestoreService _firestoreService = FirestoreService.firestoreService;


  Future<MUser> getSessionOwner() async {
    MUser currentUser = _getCurrentUser();
    if (currentUser.authState == AuthState.SUCCESFULL) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestoreService
          .getUserWithDocumentId(documentId: currentUser.userId!);
      MUser getUser = MUser.fromJson(snapshot.data() as Map<String, dynamic>);
      return getUser;
    } else {
      MUser errorUser =
      CreateMUser.createMUserObject(AuthState.ERROR, null, null);
      return errorUser;
    }
  }

  MUser _getCurrentUser() {
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

  Future<void> signOut() async {
    await _authService.signOut();
  }

}