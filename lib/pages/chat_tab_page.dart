import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_chat/pages/shimmer.dart';
import 'package:online_chat/pages/write_message_page.dart';
import 'package:online_chat/view_model/chat_tab_page_view_model.dart';
import 'package:provider/provider.dart';
import '../model/chat.dart';
import '../model/m_user.dart';
import 'chat_screen/style.dart';

class ChatTabPage extends StatelessWidget {
  final MUser gelenSessionOwner;

  ChatTabPage({required this.gelenSessionOwner});

  @override
  Widget build(BuildContext context) {
    return Provider<ChatTabPageViewModel>(
      create: (context) => ChatTabPageViewModel(),
      builder: (BuildContext context, child) {
        return Scaffold(
            backgroundColor: Color(0xff5b61b9),
            body: FutureBuilder<List<Chat>>(
              future: Provider.of<ChatTabPageViewModel>(context, listen: false)
                  .getAllChat(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Chat> chatList = snapshot.data!;
                  if (chatList.length == 0) {
                    return Center(
                      /// Buraya bir refresh indicator yerlestircem
                      child: Text("Hic bir sohbet bulunamadi"),
                    );
                  } else {
                    return BodyWidget(
                        chatList: chatList,
                        gelenSessionOwner: gelenSessionOwner);
                  }
                }
                return LoadingListPage();
                //return Center(child: CircularProgressIndicator());
              },
            ));
      },
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    super.key,
    required this.chatList,
    required this.gelenSessionOwner,
  });

  final List<Chat> chatList;
  final MUser gelenSessionOwner;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30, left: 40),
          height: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                text: 'Chat with\nyour friends',
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(height: 25),
              SizedBox(
                height: 60,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      MUser reveiverUser = MUser(
                          userId: chatList[index].receiverUserId,
                          email: "gerekmez",
                          displayName: chatList[index].receiverDisplayName,
                          photoUrl: chatList[index].receiverPhotoUrl);
                      // Su anda avatar tiklanabilir degil.
                      return Avatar(
                          avatarUrl: chatList[index].receiverPhotoUrl);
                    }),
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20),
            height: MediaQuery.of(context).size.height - 220,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  MUser reveiverUser = MUser(
                      userId: chatList[index].receiverUserId,
                      email: "gerekmez",
                      displayName: chatList[index].receiverDisplayName,
                      photoUrl: chatList[index].receiverPhotoUrl);
                  return Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => WriteMessagePage(
                              receiverUser: reveiverUser,
                              sessionOwner: gelenSessionOwner,
                            ),
                          ),
                        );
                      },
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PrimaryText(text: chatList[index].receiverDisplayName, fontSize: 18),
                          PrimaryText(text: DateFormat.Hm().format(chatList[index].createdTime), color: Colors.grey, fontSize: 14),
                        ],
                      ),
                      leading: Avatar(avatarUrl: chatList[index].receiverPhotoUrl),
                      subtitle: Row(
                        children: [
                          // Burada daha guzel icon seccem
                          // chatList[index].fromMe?
                          //   Icon(Icons.call_made,size: 20,):
                          //   Icon(Icons.call_received,size: 20,),

                          SizedBox(width: 10,),
                          PrimaryText(
                              text: chatList[index].lastMessage,
                              color: Colors.grey,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis)
                        ],
                      ),


                    ),
                  );
                })

            // ListView.builder(
            //   itemCount: userList.length,
            //   itemBuilder: (context, index) => chatElement(userList[index]['avatar']!, context, userList[index]['name']!, userList[index]['message']!, userList[index]['time']!),
            // ),
            )
      ],
    );
  }
}
