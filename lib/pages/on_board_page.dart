import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/home_page.dart';
import 'package:online_chat/view_model/onboard_page_view_model.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

class OnBoardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<OnBoardPageViewModel>(
      create: (context)=>OnBoardPageViewModel(),builder: (BuildContext context, child){
        return Scaffold(
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
    },

    );
  }
}
