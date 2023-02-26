import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_chat/model/chat.dart';
import 'package:online_chat/model/m_user.dart';

import '../model/message.dart';

class FirestoreService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirestoreService _firestoreService =
  FirestoreService._internal();

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  static get firestoreService => _firestoreService;

  Future<void> addUserToFirestore(MUser mUser) {
    final userCollectionRef = _firestore.collection('users');
    return userCollectionRef
        .doc(mUser.userId)
        .set(mUser.toJson(), SetOptions(merge: true))
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserWithDocumentId(
      {required String documentId}) {
    final userCollectionRef = _firestore.collection('users');
    Future<DocumentSnapshot<Map<String, dynamic>>> getUser =
    userCollectionRef.doc(documentId).get();
    return getUser;
  }

  Stream<QuerySnapshot<Object?>> getAllUsers() {
    final Stream<QuerySnapshot> _usersStream =
    _firestore.collection('users').snapshots();
    return _usersStream;
  }

  recordToSessionOwnerFirestore({required MUser sessionOwner,
    required MUser receiverUser,
    required Message message,
    required CollectionReference<Map<String, dynamic>> dialogCollectionRef}) {
    // Once mesaji gonderene kaydetcem
    return dialogCollectionRef
        .doc("${sessionOwner.userId}--${receiverUser.userId}")
        .collection("messages")
        .doc()
        .set(message.toJson(), SetOptions(merge: true))
        .then((value) => print("Message Added"))
        .catchError((error) => print("Failed to add message: $error"));
  }

  recordToReceiverUserFirestore({required MUser receiverUser,
    required MUser sessionOwner,
    required Message message,
    required CollectionReference<Map<String, dynamic>> dialogCollectionRef}) {
    Message updatedMessage = message;
    updatedMessage.fromMe = false;

    /// Daha sonra benden mi alanini degistir karsi taraf icin kaydet
    return dialogCollectionRef
        .doc("${receiverUser.userId}--${sessionOwner.userId}")
        .collection("messages")
        .doc()
        .set(updatedMessage.toJson(), SetOptions(merge: true))
        .then((value) => print("Message Added"))
        .catchError((error) => print("Failed to add message: $error"));
  }


  addMessageToFirestore({required MUser receiverUser,
    required MUser sessionOwner,
    required Message message}) {
    final dialogCollectionRef = _firestore.collection('dialog');
    recordToSessionOwnerFirestore(
        sessionOwner: sessionOwner,
        receiverUser: receiverUser,
        message: message,
        dialogCollectionRef: dialogCollectionRef);
    recordToReceiverUserFirestore(
        receiverUser: receiverUser,
        sessionOwner: sessionOwner,
        message: message,
        dialogCollectionRef: dialogCollectionRef);

    /// Chat field kayit
    Chat chat = Chat(sessionOwnerId: sessionOwner.userId!,
        receiverUserId: receiverUser.userId!,
        lastMessage: message.content,
        createdTime: message.createdTime,
        receiverPhotoUrl: receiverUser.photoUrl!);
    return dialogCollectionRef
        .doc("${sessionOwner.userId}--${receiverUser.userId}")
        .set(chat.toJson(), SetOptions(merge: true))
        .then((value) => print("Chat Added"))
        .catchError((error) => print("Failed to add chat: $error"));
  }

  Stream<QuerySnapshot<Object?>> getAllMessages(
      {required MUser sessionOwner, required MUser receiverUser}) {
    final Stream<QuerySnapshot> _dialogStream = _firestore
        .collection('dialog')
        .doc("${sessionOwner.userId}--${receiverUser.userId}")
        .collection("messages").orderBy("createdTime", descending: true)
        .snapshots();
    return _dialogStream;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllChat({required String sessionOwnerId}) {
    Future<QuerySnapshot<Map<String, dynamic>>> allChat = _firestore
        .collection('dialog')
        .where("sessionOwnerId", isEqualTo: sessionOwnerId)
        .get();
    return allChat;
  }
}
