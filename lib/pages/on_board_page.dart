import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/home_page.dart';
import 'package:online_chat/view_model/onboard_page_view_model.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

class OnBoardPage extends StatelessWidget {

  Widget build(BuildContext context) {
    final User? currentUser =
        Provider.of<OnBoardPageViewModel>(context, listen: false).currentUser;
    if (currentUser != null) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
/* return Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, AsyncSnapshot userSnapshot) {
                if (userSnapshot.hasError) {
                  return Center(
                    child: Text("Beklenmeyen bir hata Olustu"),
                  );
                } else {
                  if (userSnapshot.hasData) {
                    print("snapshotdaki data: ${userSnapshot.data}");
                    return HomePage();
                  } else {
                    return LoginPage();
                  }
                }
              }),
        );
*/
