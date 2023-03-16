
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';
import 'dart:io';
class ProfileTabPageViewModel {
  AuthService _authService = AuthService.authService;


  final picker=ImagePicker();
  XFile? _image;

  XFile? get image => _image;
Future<void> pickGaleryImage(BuildContext context)async{
final pickedFile=await picker.pickImage(source: ImageSource.gallery,imageQuality: 100);
if(pickedFile!=null){
  _image=XFile(pickedFile.path);
}
}

  Future<void> pickCameraImage(BuildContext context)async{
    final pickedFile=await picker.pickImage(source: ImageSource.camera,imageQuality: 100);
    if(pickedFile!=null){
      _image=XFile(pickedFile.path);
    }
  }

  Future<void> pickImage(BuildContext context)  {
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
                     pickCameraImage(context);
                    },
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                  ),
                  ListTile(
                    onTap: () {
                       pickGaleryImage(context);
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

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
