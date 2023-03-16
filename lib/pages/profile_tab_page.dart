import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_chat/view_model/profile_tab_page_view_model.dart';
import 'package:provider/provider.dart';

import '../model/m_user.dart';
import '../view_model/general_page_view_model.dart';

class ProfileTabPage extends StatelessWidget {
  final MUser gelenSessionOwner;

  ProfileTabPage({required this.gelenSessionOwner});

  @override
  Widget build(BuildContext context) {
    return Provider(
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
          body: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: _TopPortion(
                    gelenSessionOwner: gelenSessionOwner,
                  )),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "${gelenSessionOwner.displayName}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.extended(
                            onPressed: () {},
                            heroTag: 'follow',
                            elevation: 0,
                            label: const Text("Follow"),
                            icon: const Icon(Icons.person_add_alt_1),
                          ),
                          const SizedBox(width: 16.0),
                          FloatingActionButton.extended(
                            onPressed: () {},
                            heroTag: 'mesage',
                            elevation: 0,
                            backgroundColor: Colors.red,
                            label: const Text("Message"),
                            icon: const Icon(Icons.message_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _ProfileInfoRow()
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Posts", 900),
    ProfileInfoItem("Followers", 120),
    ProfileInfoItem("Following", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;

  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  final MUser gelenSessionOwner;

  _TopPortion({Key? key, required this.gelenSessionOwner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage("${gelenSessionOwner.photoUrl}")),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: IconButton(
                        icon: Icon(Icons.camera),
                        onPressed: () async{
                          await Provider.of<ProfileTabPageViewModel>(context,listen: false).pickGaleryImage(context);
                        },
                      )),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
