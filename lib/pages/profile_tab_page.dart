import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/profile_setting_page.dart';
import 'package:online_chat/view_model/profile_tab_page_view_model.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';
import '../view_model/general_page_view_model.dart';

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
    print("profil sayfasi build calisti");
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
              title: Text('Profile Information'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) => ProfileTabPageViewModel(),
                                child: ProfileSettingPage(
                                  gelenSessionOwner: newSessionOwner,
                                ),
                              ),
                            ),
                          )
                          .then((value) => onGoBack(value));
                      ;
                    },
                    icon: Icon(Icons.settings))
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage("${newSessionOwner.photoUrl}"),
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Provider.of<ProfileTabPageViewModel>(context)
                                .image ==
                            null
                        ? Image.network("${newSessionOwner.photoUrl}")
                        : Image.file(File(
                                Provider.of<ProfileTabPageViewModel>(context)
                                    .image!
                                    .path)
                            .absolute),
                  ),
                ),
                CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: IconButton(
                      icon: Icon(Icons.camera),
                      onPressed: () async {
                        await Provider.of<ProfileTabPageViewModel>(context,
                                listen: false)
                            .pickImage(context, newSessionOwner.userId!);
                      },
                    )),
                ListTile(
                  title: Text("Display Name"),
                  subtitle: Text("${newSessionOwner.displayName}"),
                ),
                ListTile(
                  title: Text("E mail "),
                  subtitle: Text("${newSessionOwner.email}"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      /// Sign out yaparken bunu kullan:
                      /// Her ne kadar uygulamanin initial route'ni belirtmemis olsak bile Uygulamamiz varsayilan olarak
                      /// slash (/) ile aslar
                      await Provider.of<GeneralPageViewModel>(context,
                              listen: false)
                          .signOut();

                      Navigator.of(context, rootNavigator: true)
                          .popUntil(ModalRoute.withName("/"));
                      // final logout = await ExitAppHelper.exitApp(context);
                      // print("logout degeri : ${logout}");
                      // if (logout == true) {
                      //   try {
                      //     await FirebaseAuth.instance.signOut();
                      //     await Provider.of<PeopleTabPageViewModel>(context,
                      //             listen: false)
                      //         .signOut;
                      //     print("current user degeri: ${_authService.currentUser()}");
                      //     // Navigator.of(context, rootNavigator: true)
                      //     //     .popUntil(ModalRoute.withName("/loginPage"));
                      //   } catch (error) {
                      //     print("hata: ${error}");
                      //   }
                      // }
                    },
                    child: Text("Log Out"))
              ],
            ),
          );
        }
        return Center(child: Text("loading"));
      },
    );
  }
}
