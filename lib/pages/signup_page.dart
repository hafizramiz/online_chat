import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/view_model/sign_up_page_view_model.dart';
import 'package:provider/provider.dart';
import '../helpers/alert_dialog_helper.dart';
import '../model/m_user.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpPageViewModel>(
      create: (context) => SignUpPageViewModel(),
      builder: (BuildContext context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up ",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text("Create Account"),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Name and Surname';
                          }
                          return null;
                        },
                        controller: Provider.of<SignUpPageViewModel>(context)
                            .displayNameController,
                        decoration: InputDecoration(
                            hintText: "Full Name",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your e-mail';
                          }
                          return null;
                        },
                        controller:
                            Provider.of<SignUpPageViewModel>(context).emailController,
                        decoration: InputDecoration(
                            hintText: "E mail",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        controller:
                            Provider.of<SignUpPageViewModel>(context).passwordController,
                        decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          } else if (Provider.of<SignUpPageViewModel>(context,
                                      listen: false)
                                  .passwordController
                                  .text !=
                              Provider.of<SignUpPageViewModel>(context, listen: false)
                                  .againPasswordController
                                  .text) {
                            return "Sifreler eslesmiyor";
                          }
                          return null;
                        },
                        controller: Provider.of<SignUpPageViewModel>(context)
                            .againPasswordController,
                        decoration: InputDecoration(
                            hintText: "Password Again",
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    /// isloading'i set ettim.
                    Provider.of<SignUpPageViewModel>(context,listen: false).isLoading=true;
                    final MUser createdUser =
                        await Provider.of<SignUpPageViewModel>(context, listen: false)
                            .createAndSaveUserWithEmailAndPassword();
                    if (createdUser.authState == AuthState.SUCCESFULL) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                      Provider.of<SignUpPageViewModel>(context,listen: false).isLoading=false;
                    } else if (createdUser.authState == AuthState.ERROR) {
                       AlertDialogHelper.showMyDialog(
                          context: context,
                          alertDialogTitle: "Uyari",
                          alertDialogContent: "Hata Olustu",
                          onPressed: () {
                            Navigator.pop(context);
                          });
                      Provider.of<SignUpPageViewModel>(context,listen: false).isLoading=false;
                    } else if (createdUser.authState ==
                        AuthState.WEAKPASSWORD) {
                       AlertDialogHelper.showMyDialog(
                          context: context,
                          alertDialogTitle: "Uyari",
                          alertDialogContent: "Weak Password",
                          onPressed: () {
                            Navigator.pop(context);
                          });
                       Provider.of<SignUpPageViewModel>(context,listen: false).isLoading=false;
                    } else if (createdUser.authState == AuthState.EMAILINUSE) {
                       AlertDialogHelper.showMyDialog(
                          context: context,
                          alertDialogTitle: "Uyari",
                          alertDialogContent: "E mail already in use",
                          onPressed: () {
                            Navigator.pop(context);
                          });
                      Provider.of<SignUpPageViewModel>(context,listen: false).isLoading=false;
                    } else {
                      AlertDialogHelper.showMyDialog(
                          context: context,
                          alertDialogTitle: "Uyari",
                          alertDialogContent: "Beklenmeyen hata olustu",
                          onPressed: () {
                            Navigator.pop(context);
                          });
                      Provider.of<SignUpPageViewModel>(context,listen: false).isLoading=false;
                    }
                  }
                },
                child: Provider.of<SignUpPageViewModel>(context).getisLoading==true?SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ):
                Text("Sign Up"),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     MUser createdGoogleUser =
              //         await Provider.of<ViewModel>(context, listen: false)
              //             .signInWithGoogle();
              //     print("google sign in tiklandi");
              //     if (createdGoogleUser.authState == AuthState.SUCCESFULL) {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => HomePage()));
              //     } else {
              //       return AlertDialogHelper.showMyDialog(
              //           context: context,
              //           alertDialogTitle: "Uyari",
              //           alertDialogContent: "Hata Olustu",
              //           onPressed: () {
              //             Navigator.pop(context);
              //           });
              //     }
              //   },
              //   child: Provider.of<ViewModel>(context).state == ViewState.BUSY
              //       ? SizedBox(
              //           width: 10,
              //           height: 10,
              //           child: CircularProgressIndicator(
              //             color: Colors.white,
              //           ),
              //         )
              //       : Text("Sign in with Google"),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text("Log in"),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
