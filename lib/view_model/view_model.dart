import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/model/chat.dart';
import 'package:online_chat/services/auth_service.dart';
import '../helpers/create_muser_object.dart';
import '../model/m_user.dart';
import '../model/message.dart';
import '../services/firestore_service.dart';

enum ViewState { IDLE, BUSY }

class ViewModel with ChangeNotifier {
  AuthService _authService = AuthService.authService;
  FirestoreService _firestoreService = FirestoreService.firestoreService;
  ViewState _state = ViewState.IDLE;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController againPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  /// Burada user nesnesi tanimla. Firestoreden
  /// veriyi cek ve bu nesnenin icini doldur.Null ise home page'e gonderme
  @override
  Stream<User?> authStateChanges() {
    Stream<User?> authStream = _authService.authStateChanges();
    return authStream;
  }

  Future<MUser> createAndSaveUserWithEmailAndPassword() async {
    late MUser createdUser;
    try {
      state = ViewState.BUSY;
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
    } finally {
      state = ViewState.IDLE;
    }
    return createdUser;
  }

  Future<MUser> signInWithEmailAndPassword() async {
    late MUser loggedUser;
    try {
      state = ViewState.BUSY;
      User? user = await _authService.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (user != null) {
        loggedUser = CreateMUser.createMUserObject(
            AuthState.SUCCESFULL, user.uid, user.email);
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
    } finally {
      state = ViewState.IDLE;
      print("Her halde girilen finally");
    }
    return loggedUser;
  }

  Future<MUser> signInWithGoogle() async {
    MUser createdGoogleUser;
    try {
      state = ViewState.BUSY;
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
    } finally {
      state = ViewState.IDLE;
    }
    return createdGoogleUser;
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
