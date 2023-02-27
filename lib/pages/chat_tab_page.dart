import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/chat.dart';
import '../view_model/view_model.dart';

class ChatTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Chat Tab Page Build');
    return Scaffold(
        appBar: AppBar(
          title: Text('Chats'),
        ),
        body: FutureBuilder<List<Chat>>(
          future: Provider.of<ViewModel>(context, listen: false).getAllChat(),
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
                      return ListTile(
                        onTap: () {
                          // Navigator.of(context, rootNavigator: true)
                          //     .push(MaterialPageRoute(
                          //     builder: (context) => WriteMessagePage(
                          //       receiverUser: allUserList[index],
                          //       sessionOwner: sessionOwner,
                          //     )));
                        },
                        title: Text("${chatList[index].receiverDisplayName}"),
                        trailing: Icon(Icons.chevron_right),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "${chatList[index].receiverPhotoUrl}"),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(chatList[index].lastMessage),
                            Text(
                                "${DateFormat.Hm().format(chatList[index].createdTime)}")
                          ],
                        ),
                      );
                    });
              }
            }
            return Text("loading");
          },
        ));
  }
}
