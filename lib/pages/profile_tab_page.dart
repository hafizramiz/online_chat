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
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        File(
                        Provider.of<ProfileTabPageViewModel>(context)
                            .image!
                            .path)
                        .absolute),
                  ),
                ),

                SizedBox(height: 20,),

                // CachedNetworkImage(
                //   imageUrl:newSessionOwner.photoUrl!,
                //   imageBuilder:
                //       (context, imageProvider) =>
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Card(
                //           elevation: 10,
                //           shape: RoundedRectangleBorder(
                //               borderRadius:
                //               BorderRadius.circular(10),
                //               side: const BorderSide(width: 3, color: Colors.grey)),
                //           child: Container(
                //             decoration: BoxDecoration(
                //               //border: Border.all(width: 2,color: Colors.grey),
                //               borderRadius:
                //               BorderRadius.circular(10),
                //               image: DecorationImage(
                //                 image: imageProvider,
                //                 fit: BoxFit.cover,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //   placeholder: (context, url) =>
                //   const Center(child: CircularProgressIndicator()),
                //   errorWidget: (context, url, error) =>
                //       Icon(Icons.error),
                // ),


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
                      await CacheManager2.signOut.write("log out yapildi");
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
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
