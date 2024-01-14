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
            appBar: AppBar(
              title: Text('Profile Settings'),
            ),
            body: SingleChildScrollView(
              child: ChangeNotifierProvider(
                create: (context) => ProfileTabPageViewModel(),
                child: Consumer<ProfileTabPageViewModel>(
                  builder: (_, provider, child) {
                    return Container(
                      padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                      height: MediaQuery.of(context).size.height - 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 100,),
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              child: Provider.of<ProfileTabPageViewModel>(
                                              context)
                                          .image ==
                                      null
                                  ? Image.network(
                                      height: 200.0,
                                      width: 200.0,
                                      fit: BoxFit.cover,
                                      "${newSessionOwner.photoUrl}")
                                  : Image.file(
                                      height: 150.0,
                                      width: 150.0,
                                      fit: BoxFit.cover,
                                      File(Provider.of<ProfileTabPageViewModel>(
                                                  context)
                                              .image!
                                              .path)
                                          .absolute),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Full Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xfff5f8fd),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: TextFormField(
                                // controller: provider.displayNameController,
                                validator: (value) {
                                  if (value == null ||
                                      value?.trim().length == 0) {
                                    return 'Please write something';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "${newSessionOwner.displayName}",
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 70, vertical: 17),
                                  textStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                await provider.pickImage(
                                    context, gelenSessionOwner.userId!);
                              },
                              child: Text(
                                "Change Profile Picture",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 100, vertical: 17),
                                  textStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                await provider.deleteUser();
                              },
                              child: Text(
                                "Delete Account",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );

          // return Scaffold(
          //   backgroundColor: Color(0xff5b61b9),
          //   body: ListView(children: [
          //     // App bar
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 10),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           ElevatedButton(
          //             child:
          //             PrimaryText(text: 'Settings', color: Colors.black87),
          //             onPressed: () {
          //               Navigator.of(context, rootNavigator: true)
          //                   .push(
          //                 MaterialPageRoute(
          //                   builder: (context) => ChangeNotifierProvider(
          //                     create: (context) =>
          //                         ProfileTabPageViewModel(),
          //                     child: ProfileSettingPage(
          //                       gelenSessionOwner: newSessionOwner,
          //                     ),
          //                   ),
          //                 ),
          //               )
          //                   .then((value) => onGoBack(value));
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //     Container(
          //       padding: EdgeInsets.only(top: 30, left: 40),
          //       height: 200,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           PrimaryText(
          //             text: 'Profile \nInformation',
          //             fontSize: 30,
          //             color: Colors.white,
          //             fontWeight: FontWeight.w900,
          //           ),
          //         ],
          //       ),
          //     ),
          //
          //     Container(
          //       padding: EdgeInsets.only(top: 30, left: 20, right: 20),
          //       height: MediaQuery.of(context).size.height - 100,
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(40),
          //           topRight: Radius.circular(40),
          //         ),
          //       ),
          //       child: Column(children: [
          //         Stack(children: [
          //           Center(
          //             child: ClipRRect(
          //               borderRadius: BorderRadius.all(Radius.circular(10)),
          //               child: Provider.of<ProfileTabPageViewModel>(context)
          //                   .image ==
          //                   null
          //                   ? Image.network(
          //                   height: 200.0,
          //                   width: 200.0,
          //                   fit: BoxFit.cover,
          //                   "${newSessionOwner.photoUrl}")
          //                   : Image.file(
          //                   height: 150.0,
          //                   width: 150.0,
          //                   fit: BoxFit.cover,
          //                   File(Provider.of<ProfileTabPageViewModel>(
          //                       context)
          //                       .image!
          //                       .path)
          //                       .absolute),
          //             ),
          //           ),
          //           Positioned(
          //             bottom: 0,
          //             left: 210,
          //             child: Container(
          //               child: ElevatedButton(
          //                 child: Icon(Icons.edit),
          //                 onPressed: () async {
          //                   await Provider.of<ProfileTabPageViewModel>(context,
          //                       listen: false)
          //                       .pickImage(context, newSessionOwner.userId!);
          //                 },
          //               ),
          //             ),
          //           ),
          //         ],),
          //         SizedBox(
          //           height: 20,
          //         ),
          //         ListTile(
          //           // title: Text("Display Name"),
          //           title: Text(
          //             "Full Name",
          //             style:
          //             TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          //           ),
          //           subtitle: Text(
          //             "${newSessionOwner.displayName}",
          //             style: TextStyle(fontSize: 24),
          //           ),
          //         ),
          //         ListTile(
          //           title: Text(
          //             "Email ",
          //             style:
          //             TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          //           ),
          //           subtitle: Text(
          //             "${newSessionOwner.email}",
          //             style: TextStyle(fontSize: 24),
          //           ),
          //         ),
          //         SizedBox(
          //           height: 20,
          //         ),
          //         ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //               backgroundColor: Colors.grey,
          //               padding: EdgeInsets.symmetric(
          //                   horizontal: 70, vertical: 20),
          //               textStyle: TextStyle(
          //                   fontSize: 30, fontWeight: FontWeight.bold)),
          //           onPressed: () async {
          //             /// Sign out yaparken bunu kullan:
          //             /// Her ne kadar uygulamanin initial route'ni belirtmemis olsak bile Uygulamamiz varsayilan olarak
          //             /// slash (/) ile aslar
          //             await Provider.of<GeneralPageViewModel>(context,
          //                 listen: false)
          //                 .signOut();
          //             await CacheManager2.signOut.write("log out yapildi");
          //             Navigator.of(context, rootNavigator: true)
          //                 .popUntil(ModalRoute.withName("/"));
          //           },
          //           child: Text(
          //             "Log Out",
          //             style: TextStyle(
          //                 fontSize: 20,
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.w700),
          //           ),
          //         ),
          //       ]),
          //     ),
          //   ]),
          // );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
