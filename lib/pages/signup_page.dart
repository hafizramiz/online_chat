import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/home_page.dart';
import 'package:provider/provider.dart';
import '../helpers/alert_dialog_helper.dart';
import '../model/m_user.dart';
import '../view_model/view_model.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
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
                    controller:
                        Provider.of<ViewModel>(context).displayNameController,
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
                    controller: Provider.of<ViewModel>(context).emailController,
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
                        Provider.of<ViewModel>(context).passwordController,
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
                      } else if (Provider.of<ViewModel>(context, listen: false)
                              .passwordController
                              .text !=
                          Provider.of<ViewModel>(context, listen: false)
                              .againPasswordController
                              .text) {
                        return "Sifreler eslesmiyor";
                      }
                      return null;
                    },
                    controller:
                        Provider.of<ViewModel>(context).againPasswordController,
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
                /// View modeldeki metodu cagiriyorum

                final MUser createdUser =
                    await Provider.of<ViewModel>(context, listen: false)
                        .createAndSaveUserWithEmailAndPassword();
                print("sign page: ${createdUser.authState}");

                if (createdUser.authState == AuthState.SUCCESFULL) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } else if (createdUser.authState == AuthState.ERROR) {
                  return AlertDialogHelper.showMyDialog(
                      context: context,
                      alertDialogTitle: "Uyari",
                      alertDialogContent: "Hata Olustu",
                      onPressed: () {
                        Navigator.pop(context);
                      });
                } else if (createdUser.authState == AuthState.WEAKPASSWORD) {
                  return AlertDialogHelper.showMyDialog(
                      context: context,
                      alertDialogTitle: "Uyari",
                      alertDialogContent: "Weak Password",
                      onPressed: () {
                        Navigator.pop(context);
                      });
                } else if (createdUser.authState == AuthState.EMAILINUSE) {
                  return AlertDialogHelper.showMyDialog(
                      context: context,
                      alertDialogTitle: "Uyari",
                      alertDialogContent: "E mail already in use",
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
            child: Text("Sign Up"),
          ),
          ElevatedButton(
            onPressed: () async {
              MUser createdGoogleUser =
                  await Provider.of<ViewModel>(context, listen: false)
                      .signInWithGoogle();
              print("google sign in tiklandi");
              if (createdGoogleUser.authState == AuthState.SUCCESFULL) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              } else {
                return AlertDialogHelper.showMyDialog(
                    context: context,
                    alertDialogTitle: "Uyari",
                    alertDialogContent: "Hata Olustu",
                    onPressed: () {
                      Navigator.pop(context);
                    });
              }
            },
            child: Provider.of<ViewModel>(context).state == ViewState.BUSY
                ? SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text("Sign in with Google"),
          ),
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
  }
}
