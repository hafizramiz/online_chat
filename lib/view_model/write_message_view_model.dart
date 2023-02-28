import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/m_user.dart';
import '../model/message.dart';
import '../services/firestore_service.dart';

class WriteMessageViewModel{
  FirestoreService _firestoreService = FirestoreService.firestoreService;
  TextEditingController messageController = TextEditingController();

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