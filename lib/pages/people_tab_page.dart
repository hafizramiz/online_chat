import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/write_message_page.dart';
import 'package:online_chat/view_model/people_tab_page_view_model.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';
class PeopleTabPage extends StatefulWidget {
  @override
  State<PeopleTabPage> createState() => _PeopleTabPageState();
}

class _PeopleTabPageState extends State<PeopleTabPage> {
  final ScrollController _scrollController = ScrollController();

  /// Kullanici buraya geldiyse giris yapti demektir. Token bilgisini burada database'e kayit etcem.
  String? _token;
  String? initialMessage;
  bool _resolved = false;







  @override
  void initState() {
    print("init state calisti");
    /// Deneme yapcam
    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
          _resolved = true;
          initialMessage = value?.data.toString();
        },
      ),
    );


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });


    _scrollController.addListener(loadMoreUsers);
    Provider.of<PeopleTabPageViewModel>(context, listen: false)
        .getInitalUsersAndSetToList();
    super.initState();
  }

  void loadMoreUsers() async {
    bool loaddegiskeni =
        Provider.of<PeopleTabPageViewModel>(context, listen: false)
            .isLoadMoreRunning;
    print("load degiskeni: $loaddegiskeni");
    if (_scrollController.position.pixels==
            _scrollController.position.maxScrollExtent &&
        Provider.of<PeopleTabPageViewModel>(context, listen: false)
                .isLoadMoreRunning ==
            false
        &&
        Provider.of<PeopleTabPageViewModel>(context, listen: false)
            .hasNextPage == true
        &&
        Provider.of<PeopleTabPageViewModel>(context, listen: false)
            .isFirstPageRunning == false
    ) {
      print("Veri cekmeye basladi");
      await Provider.of<PeopleTabPageViewModel>(context, listen: false)
          .getMoreUsersAndSetToList();
    } else {
      print("Su an bosta");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage mesaj){
      print("elde edilen mesaj: ${mesaj}");
      print("elde edilen mesaj notification bolumu: ${mesaj.notification.runtimeType}");
      RemoteNotification notification=mesaj.notification!;
      print("notification body: ${notification.body}");
      print("elde edilen mesaj data bolumu: ${mesaj.data}");
    });




    late MUser sessionOwner =
        Provider.of<PeopleTabPageViewModel>(context).sessionOwner;
    List<MUser> allUserList =
        Provider.of<PeopleTabPageViewModel>(context).allUserList;
    return Scaffold(
      appBar: AppBar(
        title: Text('People'),
        actions: [
          TextButton(
              onPressed: () async {
                /// Sign out yaparken bunu kullan:
                /// Her ne kadar uygulamanin initial route'ni belirtmemis olsak bile Uygulamamiz varsayilan olarak
                /// slash (/) ile aslar
                await Provider.of<PeopleTabPageViewModel>(context,listen: false).signOut();
                Navigator.of(context, rootNavigator: true).popUntil(ModalRoute.withName("/"));
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
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: allUserList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 17),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => WriteMessagePage(
                                      receiverUser: allUserList[index],
                                      sessionOwner: sessionOwner,
                                    )));
                      },
                      title: Text("${allUserList[index].displayName}"),
                      trailing: Icon(Icons.chevron_right),
                      leading: Image.network("${allUserList[index].photoUrl}"),
                    ),
                  ),
                );
              },
            ),
          ),
          if (Provider.of<PeopleTabPageViewModel>(context).isLoadMoreRunning ==
              true)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 40),
              child: Center(child: CircularProgressIndicator()),
            )
        ],
      ),
      //_buildBody(allUserList, sessionOwner, pageStatus),
    );
  }


}
