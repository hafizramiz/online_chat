import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_chat/model/message.dart';
import 'package:online_chat/view_model/write_message_view_model.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';
import 'chat_screen/style.dart';

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
          backgroundColor: Color(0xff5b61b9),
          // appBar: buildAppBar(),
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
                    return ListView(
                      children: [
                        customAppBar(context),
                        header(),
                        // _buildMessageList(messageList, context),
                        chatArea(context,messageList)
                      ],
                    );

                    //  return _buildMessageList(messageList, context);
                  }
                }
              }),
        );
      },
    );
  }

  Padding customAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              child: PrimaryText(text: 'Back', color: Colors.black),
              onPressed: () => {Navigator.pop(context)}),
        ],
      ),
    );
  }

  Padding header() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryText(
            text: receiverUser.displayName!,
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
          Avatar(
            avatarUrl: receiverUser.photoUrl!,
            width: 45,
            height: 45,
          )
        ],
      ),
    );
  }

  Container chatArea(BuildContext context, List<Message> messageList) {
    return Container(
        height: MediaQuery.of(context).size.height - 255,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40)),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 355,
              padding: EdgeInsets.only(top: 50, left: 40, right: 40),
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                controller: _controller,
                itemCount: messageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return messageList[index].fromMe == true
                      ? sender(
                          messageList[index].content,
                          DateFormat.Hm()
                              .format(messageList[index].createdTime))
                      : receiver(
                          messageList[index].content,
                          DateFormat.Hm()
                              .format(messageList[index].createdTime),
                        );
                  //return _showMessageWidget(currentMessage: messageList[index]);
                },
              ),


            ),
            writeMessageTextField(context),
          ],
        ));
  }

  Widget sender(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PrimaryText(text: time, color: Colors.grey, fontSize: 14),
          ),
          Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 280),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(0))),
            child: PrimaryText(
              text: message,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget receiver(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Avatar(avatarUrl: 'assets/avatar-1.png', width: 30, height: 30),
              Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(25))),
                child: PrimaryText(
                  text: message,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PrimaryText(text: time, color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Container writeMessageTextField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) {
            if (value == null || value?.trim().length == 0) {
              return 'Please write something';
            }
            return null;
          },
          controller:
              Provider.of<WriteMessageViewModel>(context).messageController,
          decoration: InputDecoration(
            fillColor: Colors.grey[200],
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            hintText: 'Type your message...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RawMaterialButton(
                constraints: BoxConstraints(minWidth: 0),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await Provider.of<WriteMessageViewModel>(context,
                            listen: false)
                        .addMessageToFirestore(
                            receiverUser: receiverUser,
                            sessionOwner: sessionOwner);
                    Provider.of<WriteMessageViewModel>(context, listen: false)
                        .messageController
                        .clear();
                    /// Firebase kayittan sonra post yapicam.Yani send push Notitification
                    await Provider.of<WriteMessageViewModel>(context,
                            listen: false)
                        .sendPushNotification(
                            receivedUser: receiverUser,
                            sessionOwner: sessionOwner);
                  }
                  _scrollDown();

                },
                elevation: 2.0,
                fillColor: Color(0xff5b61b9),
                child: Icon(Icons.send, size: 22.0, color: Colors.white),
                padding: EdgeInsets.all(10.0),
                shape: CircleBorder(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
