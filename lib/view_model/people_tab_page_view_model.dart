import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../helpers/create_muser_object.dart';
import '../model/m_user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';


class PeopleTabPageViewModel with ChangeNotifier {
  FirestoreService _firestoreService = FirestoreService.firestoreService;
  List<MUser> allUserList = [];
  bool isLoadMoreRunning = false;
  bool isFirstPageRunning = false;
  bool hasNextPage = true;



  Future<void> getInitalUsersAndSetToList({required sessionOwnerParam}) async {
    isFirstPageRunning = true;
    List<QueryDocumentSnapshot<Object?>> queryList =
        await _firestoreService.getInitialUsers();
    for (DocumentSnapshot documentSnapshot in queryList) {
      Map<String, dynamic> json =
          documentSnapshot.data() as Map<String, dynamic>;
      MUser mUserItem = MUser.fromJson(json);

      /// User ayristirma
      if (mUserItem.userId != sessionOwnerParam.userId) {
        allUserList.add(mUserItem);
      }
    }
     isFirstPageRunning = false;
    notifyListeners();
  }

  Future<void> getMoreUsersAndSetToList({required sessionOwnerParam}) async {
    int currentUsersCount = allUserList.length;
    MUser lastUser = allUserList.last;
    isLoadMoreRunning=true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    List<QueryDocumentSnapshot<Object?>> queryList =
        await _firestoreService.getMoreUsers(lastUser);
    for (DocumentSnapshot documentSnapshot in queryList) {
      Map<String, dynamic> json =
          documentSnapshot.data() as Map<String, dynamic>;
      MUser mUserItem = MUser.fromJson(json);

      /// User ayristirma
      if (mUserItem.userId != sessionOwnerParam.userId) {
        allUserList.add(mUserItem);
      }
    }
    hasNextPage=currentUsersCount == allUserList.length
        ? false
        : true;
    isLoadMoreRunning=false;
    print("load degiskeni degisti. false oldu");
    notifyListeners();
  }

/// Burada bazi guncellemeler yapcam Token her giriste database kayit etmemesi gerekiyor.
  /// Sadece token degisirse kayit yapmam gerekiyor.
  Future<void> saveTokenToDatabase({required sessionOwnerParam}) async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("token elde edildi: $token");
    await _firestoreService.saveTokenToDatabase(token!, sessionOwnerParam.userId!);
  }
}
