import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/on_board_page.dart';
import 'package:online_chat/services/notification_service.dart';
import 'package:online_chat/view_model/general_page_view_model.dart';
import 'package:online_chat/view_model/onboard_page_view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Background Mesaji geldi Data bolumu: ${message.data}");
  print("Background Mesaji geldi Notification bolumu: ${message.notification}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationService().setUpFlutterNotifications();
  runApp(
    Provider<GeneralPageViewModel>(
      create: (context) => GeneralPageViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
          create: (context) => OnBoardPageViewModel(), child: OnBoardPage()),
    );
  }
}


//  Burda kald?m. Hesap silme ekliycem. Daha sonra  sha 1 ve sha2 alcam.

// https://www.youtube.com/watch?v=ieOdT-p603Y&t=1098s   video    dakika 14