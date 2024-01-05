import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/helpers/alert_dialog_helper.dart';
import 'package:online_chat/pages/get_session_owner_page.dart';
import 'package:online_chat/pages/signup_page.dart';
import 'package:online_chat/services/shared_pref_service.dart';
import 'package:online_chat/view_model/login_page_view_model.dart';
import 'package:provider/provider.dart';
import '../common_widget/text_form_widget.dart';
import '../model/m_user.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    requestPermission();
    /// Uygulama ilk bu sayfayla basliyor. Burda iken foreground moddadir ve burda Foreground mesajlari dinleyebilirim.
    /// Ama main icinde de dinleyebilirim.Ve yahut baska sayfada.Ama tiklaninca spesifik sayfaya da gidebilmem gerek.
    /// Login yapmamis kullanici nasil spesifik mesaja gonderebiliriz?
    // FirebaseMessaging.onMessage.listen(NotificationService().showFlutterNotifications);
    super.initState();
  }

  void requestPermission() async {
    print("request permission calisti");
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<LoginPageViewModel>(
      create: (context) => LoginPageViewModel(),
      builder: (BuildContext context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 300,),
                Text(
                  "Log in",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text("Welcome to App"),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTextFromField(
                        obscureText: false,
                        controller: Provider.of<LoginPageViewModel>(context)
                            .emailController,
                        icon: Icons.person,
                        hintText: "E mail",
                        errorMessage: "Please enter your e-mail",
                      ),
                      MyTextFromField(
                        obscureText: true,
                        controller: Provider.of<LoginPageViewModel>(context)
                            .passwordController,
                        errorMessage: "Please enter your password",
                        hintText: "Password",
                        icon: Icons.lock,
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: () {}, child: Text("Forget password ?")),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Provider.of<LoginPageViewModel>(context, listen: false)
                          .isLoading = true;
                      MUser mUser = await Provider.of<LoginPageViewModel>(context,
                              listen: false)
                          .signInWithEmailAndPassword();
                      if (mUser.authState == AuthState.SUCCESFULL) {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => GetSessionOwnerPage()));
                        Provider.of<LoginPageViewModel>(context, listen: false)
                            .isLoading = false;
                        await CacheManager2.signOut.write("");
                      } else if (mUser.authState == AuthState.ERROR) {
                        AlertDialogHelper.showMyDialog(
                            context: context,
                            alertDialogTitle: "Uyari",
                            alertDialogContent: "Beklenmeyen hata olustu",
                            onPressed: () {
                              Navigator.pop(context);
                            });
                        Provider.of<LoginPageViewModel>(context, listen: false)
                            .isLoading = false;
                      } else if (mUser.authState == AuthState.WRONGPASSWORD) {
                        AlertDialogHelper.showMyDialog(
                            context: context,
                            alertDialogTitle: "Uyari",
                            alertDialogContent: "Hatali Sifre girdiniz",
                            onPressed: () {
                              Navigator.pop(context);
                            });
                        Provider.of<LoginPageViewModel>(context, listen: false)
                            .isLoading = false;
                      } else if (mUser.authState == AuthState.USERNOTFOUND) {
                        AlertDialogHelper.showMyDialog(
                            context: context,
                            alertDialogTitle: "Uyari",
                            alertDialogContent: "Kullanici Bulunamadi",
                            onPressed: () {
                              Navigator.pop(context);
                            });
                        Provider.of<LoginPageViewModel>(context, listen: false)
                            .isLoading = false;
                      } else {
                        AlertDialogHelper.showMyDialog(
                            context: context,
                            alertDialogTitle: "Uyari",
                            alertDialogContent: "Beklenmeyen hata olustu",
                            onPressed: () {
                              Navigator.pop(context);
                            });
                        Provider.of<LoginPageViewModel>(context, listen: false)
                            .isLoading = false;
                      }
                    }
                  },
                  child: Provider.of<LoginPageViewModel>(context).getisLoading ==
                          true
                      ? SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text("Log In"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                        },
                        child: Text("Sign Up"))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}