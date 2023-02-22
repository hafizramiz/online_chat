import 'package:cloud_firestore/cloud_firestore.dart';
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

  firstRecordToFirestore(
      {required MUser sessionOwner,
      required Message message,
        required CollectionReference<Map<String, dynamic>> dialogCollectionRef}) {
    // Once mesaji gonderene kaydetcem
    return dialogCollectionRef
        .doc(sessionOwner.userId)
        .collection("messages")
        .doc()
        .set(message.toJson(), SetOptions(merge: true))
        .then((value) => print("Message Added"))
        .catchError((error) => print("Failed to add message: $error"));
  }

  secondRecordToFirestore(
      {required MUser receiverUser,
      required Message message,
      required CollectionReference<Map<String, dynamic>> dialogCollectionRef}) {
    /// Daha sonra benden mi alanini degistir karsi taraf icin kaydet
    return dialogCollectionRef
        .doc(receiverUser.userId)
        .collection("messages")
        .doc()
        .set(message.toJson(), SetOptions(merge: true))
        .then((value) => print("Message Added"))
        .catchError((error) => print("Failed to add message: $error"));
  }

  addMessageToFirestore(
      {required MUser receiverUser,
      required MUser sessionOwner,
      required Message message}) {
    final dialogCollectionRef = _firestore.collection('dialog');
    firstRecordToFirestore(sessionOwner: sessionOwner, message: message, dialogCollectionRef: dialogCollectionRef);
    secondRecordToFirestore(receiverUser: receiverUser, message: message, dialogCollectionRef: dialogCollectionRef);
  }

  Stream<QuerySnapshot<Object?>> getAllMessages() {
    final Stream<QuerySnapshot> _dialogStream =
        _firestore.collection('dialog').snapshots();
    return _dialogStream;
  }
}
