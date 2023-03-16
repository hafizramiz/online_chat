import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/model/m_user.dart';
import 'package:online_chat/pages/deneme.dart';
import 'package:online_chat/view_model/general_page_view_model.dart';
import 'package:online_chat/view_model/profile_tab_page_view_model.dart';
import 'package:provider/provider.dart';

class ProfileTabPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    print('Profile Tab Page build');

    return Provider<ProfileTabPageViewModel>(
      create: (context) => ProfileTabPageViewModel(),
      builder: (BuildContext context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile Information'),
            actions: [
              TextButton(
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
                  child: Text(
                    "Cikis",
                    style: TextStyle(color: Colors.white),
                  )),
              IconButton(onPressed: () {}, icon: Icon(Icons.settings))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  /// Burada resmi degistirmek icin resim cek ve ya galeriden al bunu da Storage'e yokle
                  /// daha sonra ordan okuyarak goster
                  imageUrl: gelenSessionOwner.photoUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                ListTile(
                  title: Text("Display Name"),
                  subtitle: Text("${gelenSessionOwner.displayName}"),
                ),
                TextFormField(
                  // controller: Provider.of<>(context),
                ),
                ListTile(
                  title: Text("E Mail Adress"),
                  subtitle: Text("${gelenSessionOwner.email}"),
                ),
                TextFormField(),
                Text('Profildesin'),
                Text('User id: ${gelenSessionOwner.userId}'),
                ElevatedButton(
                  onPressed: () {
                    /// yeni bilgileri alip burda set ederek guncelleyebilirim.
                    /// Daha sonra kullaniciya alert dialog goster guncelleme basarili diye
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>ProfilePage1()));
                  },
                  child: Text("Save"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
