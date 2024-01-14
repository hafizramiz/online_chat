import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/on_board_page.dart';
import 'package:online_chat/pages/profile_setting_page.dart';
import 'package:online_chat/view_model/profile_tab_page_view_model.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';
import '../services/shared_pref_service.dart';
import '../view_model/general_page_view_model.dart';
import 'chat_screen/style.dart';

class ProfilePage extends StatelessWidget {
  final MUser gelenSessionOwner;

  ProfilePage({required this.gelenSessionOwner, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileDetails(
      gelenSessionOwner: gelenSessionOwner,
    );
  }
}

class ProfileDetails extends StatefulWidget {
  final MUser gelenSessionOwner;

  ProfileDetails({required this.gelenSessionOwner});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  late Future<MUser> _myFuture;

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _myFuture = Provider.of<ProfileTabPageViewModel>(context, listen: false)
        .getNewSessionOwner(widget.gelenSessionOwner.userId!);
    // return TestProfilePage();
    return FutureBuilder<MUser>(
      future: _myFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        } else if (snapshot.hasData) {
          MUser newSessionOwner = snapshot.data!;
          return Scaffold(
            backgroundColor: Color(0xff5b61b9),
            body: ListView(children: [
              // App bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child:
                          PrimaryText(text: 'Settings', color: Colors.black87),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) =>
                                      ProfileTabPageViewModel(),
                                  child: ProfileSettingPage(
                                    gelenSessionOwner: newSessionOwner,
                                  ),
                                ),
                              ),
                            )
                            .then((value) => onGoBack(value));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30, left: 40),
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: 'Profile \nInformation',
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                height: MediaQuery.of(context).size.height - 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(children: [
               Center(
                 child: ClipRRect(
                   borderRadius: BorderRadius.all(Radius.circular(100)),
                   child: Provider.of<ProfileTabPageViewModel>(context)
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
               ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    // title: Text("Display Name"),
                    title: Text(
                      "Full Name",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    subtitle: Text(
                      "${newSessionOwner.displayName}",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Email ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    subtitle: Text(
                      "${newSessionOwner.email}",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 20),
                            textStyle: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      /// Sign out yaparken bunu kullan:
                      /// Her ne kadar uygulamanin initial route'ni belirtmemis olsak bile Uygulamamiz varsayilan olarak
                      /// slash (/) ile aslar
                      await Provider.of<GeneralPageViewModel>(context,
                              listen: false)
                          .signOut();
                      await CacheManager2.signOut.write("log out yapildi");
                      Navigator.of(context, rootNavigator: true)
                          .popUntil(ModalRoute.withName("/"));
                    },
                    child: Text(
                      "Log Out",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
              ),
            ]),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
