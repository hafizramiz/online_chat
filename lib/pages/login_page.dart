import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/helpers/alert_dialog_helper.dart';
import 'package:online_chat/pages/home_page.dart';
import 'package:online_chat/pages/signup_page.dart';
import 'package:provider/provider.dart';
import '../common_widget/text_form_widget.dart';
import '../model/m_user.dart';
import '../view_model/view_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ViewModel>(context, listen: false);
    return Scaffold(
      body: Provider.of<ViewModel>(context).state == ViewState.BUSY
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        controller: _provider.emailController,
                        icon: Icons.person,
                        hintText: "E mail",
                        errorMessage: "Please enter your e-mail",
                      ),
                      MyTextFromField(
                        controller: _provider.passwordController,
                        errorMessage: "Please enter your password",
                        hintText: "Password",
                        icon: Icons.lock,
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: () {}, child: Text("Forget password ?")),
                ElevatedButton(
                  onPressed: Provider.of<ViewModel>(context).state ==
                          ViewState.BUSY
                      ? null
                      : () async {
                          print("Login tiklandi");
                          if (_formKey.currentState!.validate()) {
                            MUser mUser =
                                await _provider.signInWithEmailAndPassword();
                            if (mUser.authState == AuthState.SUCCESFULL) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            } else if (mUser.authState == AuthState.ERROR) {
                              return AlertDialogHelper.showMyDialog(
                                  context: context,
                                  alertDialogTitle: "Uyari",
                                  alertDialogContent: "Beklenmeyen hata olustu",
                                  onPressed: () {
                                    Navigator.pop(context);
                                  });
                            } else if (mUser.authState ==
                                AuthState.WRONGPASSWORD) {
                              return AlertDialogHelper.showMyDialog(
                                  context: context,
                                  alertDialogTitle: "Uyari",
                                  alertDialogContent: "Hatali Sifre girdiniz",
                                  onPressed: () {
                                    Navigator.pop(context);
                                  });
                            } else if (mUser.authState ==
                                AuthState.USERNOTFOUND) {
                              return AlertDialogHelper.showMyDialog(
                                  context: context,
                                  alertDialogTitle: "Uyari",
                                  alertDialogContent: "Kullanici Bulunamadi",
                                  onPressed: () {
                                    Navigator.pop(context);
                                  });
                            } else {
                              AlertDialogHelper.showMyDialog(
                                  context: context,
                                  alertDialogTitle: "Uyari",
                                  alertDialogContent: "Beklenmeyen hata olustu",
                                  onPressed: () {
                                    Navigator.pop(context);
                                  });
                            }
                          }
                        },
                  child: Text("Log Inn"),
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
    );
  }
}
