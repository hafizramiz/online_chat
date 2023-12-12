
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_chat/helpers/alert_dialog_helper.dart';
import 'package:online_chat/helpers/snackbar_helper.dart';
import 'package:online_chat/services/firestore_service.dart';
import 'package:online_chat/services/storage_service.dart';

import '../model/m_user.dart';
import '../services/auth_service.dart';
class ProfileTabPageViewModel with ChangeNotifier{
  AuthService _authService = AuthService.authService;
  StorageService _storageService=StorageService.storageService;
  FirestoreService _firestoreService=FirestoreService.firestoreService;
  bool _loadingggggg=false;
  bool get loading => _loadingggggg;
  MUser? newSessionOwner;

  set setLoading(bool value) {
    _loadingggggg = value;
    notifyListeners();
  }

  final _picker=ImagePicker();
  XFile? _image;

  XFile? get image => _image;
  Future<void> pickGaleryImage(BuildContext context, String userId)async{
    final pickedFile=await _picker.pickImage(source: ImageSource.gallery,imageQuality: 100);
    if(pickedFile!=null){
      _image=XFile(pickedFile.path);
      notifyListeners();
      await uploadAndUpdateProfilePicture(context: context, userId: userId, image: image);
    }
  }

  Future<void> pickCameraImage(BuildContext context,String userId)async{
    final pickedFile=await _picker.pickImage(source: ImageSource.camera,imageQuality: 100);
    if(pickedFile!=null){
      _image=XFile(pickedFile.path);
      notifyListeners();
      await uploadAndUpdateProfilePicture(context: context, userId: userId, image: image);
    }
  }

  pickImage(BuildContext context,String userId)  {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pickCameraImage(context,userId);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                  ),
                  ListTile(
                    onTap: () {
                      pickGaleryImage(context,userId);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.image),
                    title: Text("Gallery"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadAndUpdateProfilePicture({required BuildContext context, required String userId,required XFile? image})async{
    print("uploadAndUpdateProfilePicture metotu calisti");
    await _storageService.uploadProfilePictire(userId: userId, image:image);
    /// Storage'e yukledikten sonra Cloud Firestore'da da guncelleme yapiyorum.
    /// Once yukledigim Storage'den getDownloadUrl diyerek photoUrl cekmem gerekiyor.
    String newPhotoUrl=await _storageService.getDownloadUrl(userId: userId);
    try{
      await _firestoreService.updatePhotoUrl(userId: userId, newPhotoUrl: newPhotoUrl);
      //SnackBarHelper.showSnackBar(message: "Profile updated", context: context);
    }catch(error){
      print("error: $error");
     // SnackBarHelper.showSnackBar(message: "$error", context: context);
    }
    _image=null;
  }

  Future<MUser> getNewSessionOwner(String userId) async {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestoreService
          .getUserWithDocumentId(documentId: userId);
      MUser getUser = MUser.fromJson(snapshot.data() as Map<String, dynamic>);
      return getUser;
  }


  Future<void>deleteUser()async{
    await _authService.deleteUser();
  }


  Future<void> signOut() async {
    await _authService.signOut();
  }
}
