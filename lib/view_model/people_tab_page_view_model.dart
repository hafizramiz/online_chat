import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helpers/create_muser_object.dart';
import '../model/m_user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';


class PeopleTabPageViewModel with ChangeNotifier {
  AuthService _authService = AuthService.authService;
  FirestoreService _firestoreService = FirestoreService.firestoreService;
  List<MUser> allUserList = [];
  bool isLoadMoreRunning = false;
  bool isFirstPageRunning = false;
  bool hasNextPage = true;
  late MUser sessionOwner;


  PeopleTabPageViewModel() {
    sessionOwner = getCurrentUser();
  }

  Future<void> getInitalUsersAndSetToList() async {
    sessionOwner=await getSessionOwner();
    isFirstPageRunning = true;
    List<QueryDocumentSnapshot<Object?>> queryList =
        await _firestoreService.getInitialUsers();
    for (DocumentSnapshot documentSnapshot in queryList) {
      Map<String, dynamic> json =
          documentSnapshot.data() as Map<String, dynamic>;
      MUser mUserItem = MUser.fromJson(json);

      /// User ayristirma
      if (mUserItem.userId != sessionOwner.userId) {
        allUserList.add(mUserItem);
      } else {
        sessionOwner = mUserItem;
      }
    }
     isFirstPageRunning = false;
    notifyListeners();
  }

  Future<void> getMoreUsersAndSetToList() async {
    int currentUsersCount = allUserList.length;
    MUser lastUser = allUserList.last;
    print("lastUser displayName: ${lastUser.displayName}");

    isLoadMoreRunning=true;
    print("load degiskeni degisti. true oldu");
    notifyListeners();
    await Future.delayed(Duration(seconds: 4));
    List<QueryDocumentSnapshot<Object?>> queryList =
        await _firestoreService.getMoreUsers(lastUser);
    for (DocumentSnapshot documentSnapshot in queryList) {
      Map<String, dynamic> json =
          documentSnapshot.data() as Map<String, dynamic>;
      MUser mUserItem = MUser.fromJson(json);

      /// User ayristirma
      if (mUserItem.userId != sessionOwner.userId) {
        allUserList.add(mUserItem);
      } else {
        sessionOwner = mUserItem;
      }
    }
    hasNextPage=currentUsersCount == allUserList.length
        ? false
        : true;
    isLoadMoreRunning=false;
    print("load degiskeni degisti. false oldu");
    notifyListeners();
  }

  Future<void> signOut() async {
      await _authService.signOut();
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


  Future<MUser> getSessionOwner() async {
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
}
