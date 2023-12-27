import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_chat/model/message.dart';
import 'package:online_chat/view_model/write_message_view_model.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';

class WriteMessagePage extends StatelessWidget {
  final MUser sessionOwner;
  final MUser receiverUser;

  WriteMessagePage({required this.sessionOwner, required this.receiverUser});

  final _formKey = GlobalKey<FormState>();
  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.minScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<WriteMessageViewModel>(
      create: (context) => WriteMessageViewModel(),
      builder: (BuildContext context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[100],
            title: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("${receiverUser.photoUrl}"),
                ),
                title: Text(
                  "${receiverUser.displayName}",
                  style: TextStyle(color: Colors.black),
                )),
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: Provider.of<WriteMessageViewModel>(context)
                  .getAllMessages(
                      receiverUser: receiverUser, sessionOwner: sessionOwner),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                } else {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Text("There is no internet connection"),
                    );
                  } else {
                    List<QueryDocumentSnapshot<Object?>> queryList =
                        snapshot.data!.docs;
                    List<Message> messageList =
                        queryList.map((DocumentSnapshot document) {
                      Map<String, dynamic> json =
                          document.data() as Map<String, dynamic>;
                      Message message = Message.fromJson(json);
                      return message;
                    }).toList();
                    print("mesaj listesi $messageList");
                    return _buildMessageList(messageList, context);
                  }
                }
              }),
        );
      },
    );
  }

  Widget _buildMessageList(List<Message> messageList, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: ListView.builder(
          shrinkWrap: true,
          reverse: true,
          controller: _controller,
          itemCount: messageList.length,
          itemBuilder: (BuildContext context, int index) {
            return _showMessageWidget(currentMessage: messageList[index]);
          },
        )),
        Row(
          children: [
            Form(
              key: _formKey,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value?.trim().length == 0) {
                        return 'Please write something';
                      }
                      return null;
                    },
                    controller: Provider.of<WriteMessageViewModel>(context)
                        .messageController,
                    decoration: InputDecoration(
                        hintText: "Mesaj yazin",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await Provider.of<WriteMessageViewModel>(context, listen: false)
                        .addMessageToFirestore(
                            receiverUser: receiverUser,
                            sessionOwner: sessionOwner);

                    /// Firebase kayittan sonra post yapicam.Yani send push Notitification
                    await Provider.of<WriteMessageViewModel>(context, listen: false)
                        .sendPushNotification(receivedUser: receiverUser,sessionOwner: sessionOwner);
                  }
                  _scrollDown();
                  Provider.of<WriteMessageViewModel>(context, listen: false)
                      .messageController
                      .clear();
                },
                icon: Icon(Icons.send))
          ],
        )
      ],
    );
  }

  Widget _showMessageWidget({required Message currentMessage}) {
    print(DateFormat.Hm().format(currentMessage.createdTime));
    return Column(
      crossAxisAlignment: currentMessage.fromMe == true
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all( 10),
          child: Container(
            decoration: BoxDecoration(
                color: currentMessage.fromMe == true
                    ? Colors.grey[700]
                    : Colors.grey[900],
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${currentMessage.content}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("${DateFormat.Hm().format(currentMessage.createdTime)}"),
        )
      ],
    );
  }
}
