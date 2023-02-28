import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/login_page.dart';
import 'package:online_chat/pages/on_board_page.dart';
import 'package:online_chat/pages/signup_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnBoardPage(),
      initialRoute: "/loginPage",
      routes: {
        "/loginPage": (context) => LoginPage(),
        "/signUpPAge": (context) => SignUpPage(),
      },
    );
  }
}
