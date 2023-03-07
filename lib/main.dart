import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/login_page.dart';
import 'package:online_chat/pages/on_board_page.dart';
import 'package:online_chat/pages/signup_page.dart';
import 'package:online_chat/view_model/onboard_page_view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(create: (context)=>OnBoardPageViewModel(),
          child: OnBoardPage()),
    );
  }
}
