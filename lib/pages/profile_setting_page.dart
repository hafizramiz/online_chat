import 'dart:io';
import 'package:flutter/material.dart';
import 'package:online_chat/view_model/profile_tab_page_view_model.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';

class ProfileSettingPage extends StatelessWidget {
  final MUser gelenSessionOwner;

  ProfileSettingPage({required this.gelenSessionOwner});

  final _formKey = GlobalKey<FormState>();
  late Future<MUser> _myFuture;

  @override
  Widget build(BuildContext context) {
    _myFuture = Provider.of<ProfileTabPageViewModel>(context, listen: false)
        .getNewSessionOwner(gelenSessionOwner.userId!);
    return FutureBuilder<MUser>(
      future: _myFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        } else if (snapshot.hasData) {
          MUser newSessionOwner = snapshot.data!;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text('Profile Settings'),
            ),
            body: SingleChildScrollView(
              child: ChangeNotifierProvider(
                create: (context) => ProfileTabPageViewModel(),
                child: Consumer<ProfileTabPageViewModel>(
                  builder: (_, provider, child) {
                    print("image degeri: ${provider.image}");
                    // provider.displayNameController.text = gelenSessionOwner.displayName!;

                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          SizedBox(height: 150,),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Provider.of<ProfileTabPageViewModel>(context)
                                .image ==
                                null
                                ? Image.network(
                                height: 150.0,
                                width: 150.0,
                                fit: BoxFit.cover,
                                "${newSessionOwner.photoUrl}")
                                : Image.file(
                                height: 150.0,
                                width: 150.0,
                                fit: BoxFit.cover,
                                File(
                                    Provider.of<ProfileTabPageViewModel>(context)
                                        .image!
                                        .path)
                                    .absolute),
                          ),

                          // Container(
                          //   width: 150,
                          //   height: 150,
                          //   decoration: BoxDecoration(
                          //     color: Colors.black,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(100),
                          //     child: provider.image == null
                          //         ? Image.network(
                          //             "${newSessionOwner.photoUrl}")
                          //         : Image.file(
                          //             File(provider.image!.path).absolute),
                          //   ),
                          // ),
                          SizedBox(height: 20,),
                          CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: IconButton(
                                icon: Icon(Icons.camera),
                                onPressed: () async {
                                  await provider.pickImage(
                                      context, gelenSessionOwner.userId!);
                                },
                              )),
                          SizedBox(height: 20,),
                          Text("DisplayName"),
                          TextFormField(
                            // controller: provider.displayNameController,
                            validator: (value) {
                              if (value == null || value?.trim().length == 0) {
                                return 'Please write something';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "${newSessionOwner.displayName}",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await provider.deleteUser();
                              },
                              child: Text("Delete Account", style: TextStyle(color: Colors.red),)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
