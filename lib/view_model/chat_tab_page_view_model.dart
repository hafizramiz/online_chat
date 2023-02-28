import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/create_muser_object.dart';
import '../model/chat.dart';
import '../model/m_user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class ChatTabPageViewModel{
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

  Future<List<Chat>>getAllChat()async {
    MUser currentUser = getCurrentUser();
    QuerySnapshot<Map<String, dynamic>> querySnapshot=await _firestoreService.getAllChat(sessionOwnerId: currentUser.userId!);
    List<DocumentSnapshot<Map<String, dynamic>>> documentSnapList=querySnapshot.docs!;
    List<Chat>chatList=documentSnapList.map((DocumentSnapshot document) {
      Map<String,dynamic>json=document.data() as Map<String, dynamic>;
      Chat chat=Chat.fromJson(json);
      return chat;
    }).toList();
    return chatList;
  }

}