import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/get_session_owner_page.dart';
import 'package:online_chat/pages/onboding/onboding_screen.dart';
import 'package:online_chat/view_model/onboard_page_view_model.dart';
import 'package:provider/provider.dart';


class OnBoardPage extends StatelessWidget {
  Widget build(BuildContext context) {
    final User? currentUser =
        Provider.of<OnBoardPageViewModel>(context, listen: false).currentUser;
    if (currentUser != null) {
      // cikis yaptiysa buraya gircek.
      print("11");
      return GetSessionOwnerPage();
    } else {
      print("22");
      // Burda control yapip atcam.
      return OnbodingScreen();
    }
  }
}
