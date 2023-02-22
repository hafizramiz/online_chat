import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/on_board_page.dart';
import 'package:online_chat/view_model/view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider<ViewModel>(
      create: (context) => ViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: OnBoardPage());
  }
}
