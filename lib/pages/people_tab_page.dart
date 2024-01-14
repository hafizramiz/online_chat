import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/write_message_page.dart';
import 'package:online_chat/view_model/people_tab_page_view_model.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';
import '../services/notification_service.dart';
import 'chat_screen/style.dart';

class PeopleTabPage extends StatefulWidget {
  final MUser gelenSessionOwner;

  PeopleTabPage({required this.gelenSessionOwner});

  @override
  State<PeopleTabPage> createState() => _PeopleTabPageState();
}

class _PeopleTabPageState extends State<PeopleTabPage> {
  final ScrollController _scrollController = ScrollController();

  Future<void> setupInteractedMessage() async {
    /// Bu  metotu tiklaninca spesifik mesaj sayfasina gitmek icin yaziyorum
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("on message opened calisti. Degistirdim ben bunu");
    print("data run tipi: ${jsonDecode(message.data["data"]).runtimeType}");
    Map<String, dynamic> json = jsonDecode(message.data["data"]);
    print("json: ${json.runtimeType}");
    MUser receiverUser = MUser.fromJson(json);
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => WriteMessagePage(
            sessionOwner: widget.gelenSessionOwner, receiverUser: receiverUser),
      ),
    );
  }

  @override
  void initState() {
    /// Kullanici buraya geldiyse giris yapti demektir. Token bilgisini burada database'e kayit etcem.
    print("init state calisti");

    /// once token elde et
    Provider.of<PeopleTabPageViewModel>(context, listen: false)
        .saveTokenToDatabase(sessionOwnerParam: widget.gelenSessionOwner);

    _scrollController.addListener(loadMoreUsers);
    Provider.of<PeopleTabPageViewModel>(context, listen: false)
        .getInitalUsersAndSetToList(
            sessionOwnerParam: widget.gelenSessionOwner);

    /// Bu  metotlarin ikisinide tiklaninca spesifik mesaj sayfasina gitmek icin yaziyorum
    setupInteractedMessage();
    NotificationService().initNotification(
        context: context, sessionOwner: widget.gelenSessionOwner);
    super.initState();
  }

  void loadMoreUsers() async {
    bool loaddegiskeni =
        Provider.of<PeopleTabPageViewModel>(context, listen: false)
            .isLoadMoreRunning;
    print("load degiskeni: $loaddegiskeni");
    if (_scrollController
                .position.pixels ==
            _scrollController.position.maxScrollExtent &&
        Provider.of<PeopleTabPageViewModel>(context, listen: false)
                .isLoadMoreRunning ==
            false &&
        Provider.of<PeopleTabPageViewModel>(context, listen: false)
                .hasNextPage ==
            true &&
        Provider.of<PeopleTabPageViewModel>(context, listen: false)
                .isFirstPageRunning ==
            false) {
      print("Veri cekmeye basladi");
      await Provider.of<PeopleTabPageViewModel>(context, listen: false)
          .getMoreUsersAndSetToList(
              sessionOwnerParam: widget.gelenSessionOwner);
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
    List<MUser> allUserList =
        Provider.of<PeopleTabPageViewModel>(context).allUserList;
    return Scaffold(
      backgroundColor: Color(0xff5b61b9),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 40),
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: 'People',
                  fontSize: 32,
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
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: allUserList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (context) => WriteMessagePage(
                                          receiverUser: allUserList[index],
                                          sessionOwner:
                                              widget.gelenSessionOwner,
                                        )));
                          },
                         // title: Text("${allUserList[index].displayName}"),
                          title:  PrimaryText(text: allUserList[index].displayName!, fontSize: 18),
                          trailing: Icon(Icons.chevron_right),
                          leading: Avatar(avatarUrl: allUserList[index].photoUrl!),

                        ),
                      );
                    },
                  ),
                ),
                if (Provider.of<PeopleTabPageViewModel>(context)
                        .isLoadMoreRunning ==
                    true)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
              ],
            ),
          ),
        ],
      ),
      //_buildBody(allUserList, sessionOwner, pageStatus),
    );
  }
}
