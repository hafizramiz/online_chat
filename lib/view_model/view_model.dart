import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/model/chat.dart';
import 'package:online_chat/services/auth_service.dart';
import '../helpers/create_muser_object.dart';
import '../model/m_user.dart';
import '../model/message.dart';
import '../services/firestore_service.dart';

/// Her view'e karsilik bir view model olusturcam



class ViewModel with ChangeNotifier {
  AuthService _authService = AuthService.authService;
  FirestoreService _firestoreService = FirestoreService.firestoreService;

  TextEditingController messageController = TextEditingController();






  Future<bool> signOut() async {
    try {
      print("cikis basladi");
      await _authService.signOut();
      return true;
    } catch (error) {
      return false;
    }
  }

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

  Future<MUser> getUserWithDocumentId() async {
    MUser currentUser = getCurrentUser();
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

  Future<List<Chat>>getAllChat()async {
    MUser currentUser = getCurrentUser();
    QuerySnapshot<Map<String, dynamic>> querySnapshot=await _firestoreService.getAllChat(sessionOwnerId: currentUser.userId!);
    // burada modele cevirip arayuze vercem.
    List<DocumentSnapshot<Map<String, dynamic>>> documentSnapList=querySnapshot.docs!;
    List<Chat>chatList=documentSnapList.map((DocumentSnapshot document) {
      Map<String,dynamic>json=document.data() as Map<String, dynamic>;
      Chat chat=Chat.fromJson(json);
      return chat;
    }).toList();
    return chatList;
  }


  Stream<QuerySnapshot> getAllUsers() {
    final Stream<QuerySnapshot> _usersStream = _firestoreService.getAllUsers();
    return _usersStream;
  }

  Stream<QuerySnapshot> getAllMessages(
      {required MUser receiverUser, required MUser sessionOwner}) {
    print("receiver user id: ${receiverUser.userId}");
    final Stream<QuerySnapshot> _dialogStream = _firestoreService
        .getAllMessages(sessionOwner: sessionOwner, receiverUser: receiverUser);
    return _dialogStream;
  }

  Future<void> addMessageToFirestore(
      {required MUser receiverUser, required MUser sessionOwner}) async {
    var message = Message(
        content: messageController.text,
        createdTime: DateTime.now(),
        fromMe: true);
    await _firestoreService.addMessageToFirestore(
        receiverUser: receiverUser,
        sessionOwner: sessionOwner,
        message: message);
  }
}
