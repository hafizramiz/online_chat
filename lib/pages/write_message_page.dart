import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';
import '../view_model/view_model.dart';

class WriteMessagePage extends StatelessWidget {
  final MUser sessionOwner;
  final MUser receiverUser;

  WriteMessagePage({required this.sessionOwner, required this.receiverUser});

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Messaj sayfasi"),
        Text("selected user: ${receiverUser.displayName}"),
        Text("session owner user: ${sessionOwner.email}"),
        Row(
          children: [
            SizedBox(
                width: 300,
                child: Form(
                  child:  Column(children: [
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
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // print("buraya girdi");
                            // Provider.of<ViewModel>(context,listen:false).addMessageToFirestore(
                            //     receiverUser: receiverUser, sessionOwner: sessionOwner);
                          }
                          print("tiklandi");
                        },
                        child: Text("gonder"))
                  ],)
                )),
          ],
        )
      ],
    ));
  }
}

