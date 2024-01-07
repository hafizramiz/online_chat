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
          backgroundColor: Color(0xffe8ebed),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 70,
              //For moving according to the screen when the keyboard popsup.
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 180,
                            width: 600,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child:
                                  Image.asset("assets/images/friendship.png"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60),
// From here the login Credentials start.
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffe1e2e3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ]),
                        child: Form(

                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    )),
                                SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xfff5f8fd),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: MyTextFromField(
                                    obscureText: false,
                                    controller:
                                        Provider.of<LoginPageViewModel>(context)
                                            .emailController,
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),
                                    hintText: "E mail",
                                    errorMessage: "Please enter your e-mail",
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xfff5f8fd),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: MyTextFromField(
                                    obscureText: true,
                                    controller:
                                        Provider.of<LoginPageViewModel>(context)
                                            .passwordController,
                                    icon:
                                        Icon(Icons.vpn_key, color: Colors.grey),
                                    hintText: "Password",
                                    errorMessage: "Please enter your password",
                                  ),
                                ),
                              ]),
                        ),
                      ),

                      SizedBox(
                        height: 25,
                      ),

                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                            child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.w500),
                        )),
                      ),

                      SizedBox(height: 25),

                      //From here the signin buttons will occur.

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 20),
                                textStyle: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Provider.of<LoginPageViewModel>(context,
                                        listen: false)
                                    .isLoading = true;
                                MUser mUser =
                                    await Provider.of<LoginPageViewModel>(
                                            context,
                                            listen: false)
                                        .signInWithEmailAndPassword();
                                if (mUser.authState == AuthState.SUCCESFULL) {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GetSessionOwnerPage()));
                                  Provider.of<LoginPageViewModel>(context,
                                          listen: false)
                                      .isLoading = false;
                                  await CacheManager2.signOut.write("");
                                } else if (mUser.authState == AuthState.ERROR) {
                                  AlertDialogHelper.showMyDialog(
                                      context: context,
                                      alertDialogTitle: "Uyari",
                                      alertDialogContent:
                                          "Beklenmeyen hata olustu",
                                      onPressed: () {
                                        Navigator.pop(context);
                                      });
                                  Provider.of<LoginPageViewModel>(context,
                                          listen: false)
                                      .isLoading = false;
                                } else if (mUser.authState ==
                                    AuthState.WRONGPASSWORD) {
                                  AlertDialogHelper.showMyDialog(
                                      context: context,
                                      alertDialogTitle: "Uyari",
                                      alertDialogContent:
                                          "Hatali Sifre girdiniz",
                                      onPressed: () {
                                        Navigator.pop(context);
                                      });
                                  Provider.of<LoginPageViewModel>(context,
                                          listen: false)
                                      .isLoading = false;
                                } else if (mUser.authState ==
                                    AuthState.USERNOTFOUND) {
                                  AlertDialogHelper.showMyDialog(
                                      context: context,
                                      alertDialogTitle: "Uyari",
                                      alertDialogContent:
                                          "Kullanici Bulunamadi",
                                      onPressed: () {
                                        Navigator.pop(context);
                                      });
                                  Provider.of<LoginPageViewModel>(context,
                                          listen: false)
                                      .isLoading = false;
                                } else {
                                  AlertDialogHelper.showMyDialog(
                                      context: context,
                                      alertDialogTitle: "Uyari",
                                      alertDialogContent:
                                          "Beklenmeyen hata olustu",
                                      onPressed: () {
                                        Navigator.pop(context);
                                      });
                                  Provider.of<LoginPageViewModel>(context,
                                          listen: false)
                                      .isLoading = false;
                                }
                              }
                            },
                            child: Provider.of<LoginPageViewModel>(context)
                                        .getisLoading ==
                                    true
                                ? SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Sign In",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),

                      SizedBox(height: 30),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                              },
                              child: Container(
                                child: Text("Register now",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.deepPurpleAccent)),
                              ),
                            )
                          ]),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
