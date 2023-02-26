import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/chat.dart';
import '../view_model/view_model.dart';

class ChatTabPage extends StatelessWidget {
  late Future<List<Chat>> _futureChat;
  @override
  Widget build(BuildContext context) {
    print('Chat Tab Page Build');
    _futureChat = Provider.of<ViewModel>(context, listen: false).getAllChat();
    return Scaffold(
        appBar: AppBar(
          title: Text('Chats'),
        ),
        body: FutureBuilder<List<Chat>>(
          future: _futureChat,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              List<Chat> chatList = snapshot.data!;
              return Column(
                children: [
                  Text("chatList: ${chatList[0].lastMessage}"),
                ],
              );
            }
            return Text("loading");
          },
        ));
  }
}
