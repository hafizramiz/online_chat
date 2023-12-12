import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_chat/pages/write_message_page.dart';
import 'package:online_chat/view_model/chat_tab_page_view_model.dart';
import 'package:provider/provider.dart';
import '../model/chat.dart';
import '../model/m_user.dart';

class ChatTabPage extends StatelessWidget {
  final MUser gelenSessionOwner;

  ChatTabPage({required this.gelenSessionOwner});

  @override
  Widget build(BuildContext context) {
    return Provider<ChatTabPageViewModel>(
      create: (context) => ChatTabPageViewModel(),
      builder: (BuildContext context, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Chats'),
            ),
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
                    return ListView.builder(
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          MUser reveiverUser = MUser(
                              userId: chatList[index].receiverUserId,
                              email: "gerekmez",
                              displayName: chatList[index].receiverDisplayName,
                              photoUrl: chatList[index].receiverPhotoUrl);

                          return ListTile(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                      builder: (context) => WriteMessagePage(
                                            receiverUser: reveiverUser,
                                            sessionOwner: gelenSessionOwner,
                                          )));
                            },
                            title:
                                Text("${chatList[index].receiverDisplayName}"),
                            trailing: Icon(Icons.chevron_right),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "${chatList[index].receiverPhotoUrl}"),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    if (chatList[index].fromMe)
                                      Icon(Icons.call_made)
                                    else
                                      Icon(Icons.call_received),
                                    Text(chatList[index].lastMessage),
                                  ],
                                ),
                                Text(
                                    "${DateFormat.Hm().format(chatList[index].createdTime)}")
                              ],
                            ),
                          );
                        });
                  }
                }
                return Center(child: CircularProgressIndicator());
              },
            ));
      },
    );
  }
}
