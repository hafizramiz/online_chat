import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/m_user.dart';
import '../model/message.dart';
import '../services/firestore_service.dart';
import 'package:http/http.dart' as http;

class WriteMessageViewModel {
  FirestoreService _firestoreService = FirestoreService.firestoreService;
  TextEditingController messageController = TextEditingController();

  Future<void> getInitialMessages(
      {required MUser sessionOwner, required MUser receiverUser}) async {
    List<QueryDocumentSnapshot<Object?>> a =
        await _firestoreService.getInitialMessages(
            sessionOwner: sessionOwner, receiverUser: receiverUser);
  }

  Future<void> getMoreMessages() async {}

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

  Future<void> sendPushNotification(
      {required MUser receivedUser, required MUser sessionOwner}) async {
    /// Firebase'den token elde et
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firestoreService.getTokenFromDatabase(
            userId: receivedUser.userId);
    Map<String, dynamic> mapData =
        documentSnapshot.data() as Map<String, dynamic>;
    print("databaseden gelen token:${mapData["token"]}");
    String _token = mapData["token"];
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      final body = {
        "to": "$_token",
        "notification": <String,dynamic>{
          "title": "${sessionOwner.displayName}",
          "body": messageController.text,
        },
        "data": <String, dynamic>{
          "click_action":"FLUTTER_NOTIFICATION_CLICK",
          "status":"done",
          "data":sessionOwner.toJson(),
        }

      };
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(body),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:
                "key=AAAASw4f6so:APA91bHPGsNzyfvbXseiQfG3LKzIyYGHsoR-mAQxWFEO7ajdqrdHT33DqXngXTzlDlLJc5-J4_p2ij6z8RZat0lLPgR0DLhu1oG29mDYHBfZXRXmhu4wmooIpBcsWGDlW2ZYEIb9LfjU",
          });
      print("Post islemi basarili");
    } catch (error) {
      print("Post yaparken hata olustu:$error");
    }
  }
}
