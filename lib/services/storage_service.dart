import 'package:firebase_storage/firebase_storage.dart';

class StorageService{
  static final StorageService _storageService=StorageService._internal();
  static StorageService get  storageService => _storageService;
  StorageService._internal();
  factory StorageService(){
    return _storageService;
  }

  uploadProfilePictire(){
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("profileImages");
  }

}