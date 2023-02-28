import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/helpers/alert_dialog_helper.dart';
import 'package:online_chat/pages/home_page.dart';
import 'package:online_chat/pages/signup_page.dart';
import 'package:online_chat/view_model/login_page_view_model.dart';
import 'package:provider/provider.dart';
import '../common_widget/text_form_widget.dart';
import '../model/m_user.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginPageViewModel>(create: (context)=>LoginPageViewModel(),
      builder: (BuildContext context,child){
        return Scaffold(
          body: Column(
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
                      controller: Provider.of<LoginPageViewModel>(context).emailController,
                      icon: Icons.person,
                      hintText: "E mail",
                      errorMessage: "Please enter your e-mail",
                    ),
                    MyTextFromField(
                      controller: Provider.of<LoginPageViewModel>(context).passwordController,
                      errorMessage: "Please enter your password",
                      hintText: "Password",
                      icon: Icons.lock,
                    ),
                  ],
                ),
              ),
              TextButton(onPressed: () {}, child: Text("Forget password ?")),
              ElevatedButton(
                onPressed:() async {
                  print("basladi");
                  Provider.of<LoginPageViewModel>(context,listen: false).isLoading=true;
                  if (_formKey.currentState!.validate()) {
                    MUser mUser =
                    await Provider.of<LoginPageViewModel>(context,listen: false).signInWithEmailAndPassword();
                    if (mUser.authState == AuthState.SUCCESFULL) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()));
                      Provider.of<LoginPageViewModel>(context,listen: false).isLoading=false;
                    } else if (mUser.authState == AuthState.ERROR) {
                      AlertDialogHelper.showMyDialog(
                          context: context,
                          alertDialogTitle: "Uyari",
                          alertDialogContent: "Beklenmeyen hata olustu",
                          onPressed: () {
                            Navigator.pop(context);
                          });
                      Provider.of<LoginPageViewModel>(context,listen: false).isLoading=false;

                    } else if (mUser.authState ==
                        AuthState.WRONGPASSWORD) {
                      AlertDialogHelper.showMyDialog(
                          context: context,
                          alertDialogTitle: "Uyari",
                          alertDialogContent: "Hatali Sifre girdiniz",
                          onPressed: () {
                            Navigator.pop(context);
                          });
                      Provider.of<LoginPageViewModel>(context,listen: false).isLoading=false;
                    } else if (mUser.authState ==
                        AuthState.USERNOTFOUND) {
                      AlertDialogHelper.showMyDialog(
                          context: context,
                          alertDialogTitle: "Uyari",
                          alertDialogContent: "Kullanici Bulunamadi",
                          onPressed: () {
                            Navigator.pop(context);
                          });
                      Provider.of<LoginPageViewModel>(context,listen: false).isLoading=false;
                    } else {
                      AlertDialogHelper.showMyDialog(
                          context: context,
                          alertDialogTitle: "Uyari",
                          alertDialogContent: "Beklenmeyen hata olustu",
                          onPressed: () {
                            Navigator.pop(context);
                          });
                      Provider.of<LoginPageViewModel>(context,listen: false).isLoading=false;
                    }
                  }
                  print("sona gelindi");
                },
                child: Provider.of<LoginPageViewModel>(context).getisLoading==true?SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ):
                Text("Log Inn"),
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
      },
    );
  }
}
