import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/model/m_user.dart';
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
                IconButton(onPressed: () {}, icon: Icon(Icons.settings))
              ],
            ),
            body: FutureBuilder<MUser>(
              future: Provider.of<ProfileTabPageViewModel>(context, listen: false)
                  .getUserWithDocumentId(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  MUser getUser = snapshot.data as MUser;
                  if (getUser.authState == AuthState.ERROR) {
                    return Center(
                      child: Text("Something went wrong"),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          /// Burada resmi degistirmek icin resim cek ve ya galeriden al bunu da Storage'e yokle
                          /// daha sonra ordan okuyarak goster
                          imageUrl: getUser.photoUrl!,
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
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        ListTile(
                          title: Text("Display Name"),
                          subtitle: Text("${getUser.displayName}"),
                        ),
                        TextFormField(
                          // controller: Provider.of<>(context),
                        ),
                        ListTile(
                          title: Text("E Mail Adress"),
                          subtitle: Text("${getUser.email}'),"),
                        ),
                        TextFormField(),
                        Text('Profildesin'),
                        Text('User id: ${getUser.userId}'),
                        ElevatedButton(
                          onPressed: () {
                            /// yeni bilgileri alip burda set ederek guncelleyebilirim.
                            /// Daha sonra kullaniciya alert dialog goster guncelleme basarili diye
                          },
                          child: Text("Save"),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Yuklerken hata olustu'));
                }
                return const CircularProgressIndicator();
              },
            ));
      },
    );
  }
}
