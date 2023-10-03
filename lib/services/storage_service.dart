import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static final StorageService _storageService = StorageService._internal();

  static StorageService get storageService => _storageService;

  StorageService._internal();

  factory StorageService() {
    return _storageService;
  }

  Future<void> uploadProfilePictire(
      {required String userId, required XFile? image}) async {
    final imagesRef = FirebaseStorage.instance
        .ref()
        .child(userId.toString());
    try {
      TaskSnapshot taskSnapshot = await imagesRef.putFile(File(image!.path));
    } catch (error) {
      print("upload error:$error");
    }
  }

  Future<String> getDownloadUrl({required String userId}) async {
    final imagesRef = FirebaseStorage.instance
        .ref()
        .child(userId.toString());
    String newPhotoUrl = await imagesRef.getDownloadURL();
    return newPhotoUrl;
  }
}
