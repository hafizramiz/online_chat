import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/write_message_page.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';
import '../view_model/view_model.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  late MUser currentUser;
  @override
  void initState() {
    currentUser =
        Provider.of<ViewModel>(context, listen: false).getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            TextButton(
                onPressed: () async {
                  await Provider.of<ViewModel>(context, listen: false)
                      .signOut();
                  print("cikis yapildi");
                },
                child: Text(
                  "Cikis",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: StreamBuilder(
            stream:
                Provider.of<ViewModel>(context, listen: false).getAllUsers(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  List<MUser> allUserList = [];
                  late MUser sessionOwner;
                  for (DocumentSnapshot document in queryList) {
                    Map<String, dynamic> json =
                        document.data() as Map<String, dynamic>;
                    MUser mUserItem = MUser.fromJson(json);
                    if (mUserItem.userId != currentUser.userId) {
                      allUserList.add(mUserItem);
                    } else {
                      sessionOwner = mUserItem;
                    }
                  }
                  return ListView.builder(
                      itemCount: allUserList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (context) => WriteMessagePage(
                                          receiverUser: allUserList[index],
                                          sessionOwner: sessionOwner,
                                        )));
                          },
                          title: Text("${allUserList[index].displayName}"),
                          leading:
                              Image.network("${allUserList[index].photoUrl}"),
                        );
                      });
                }
              }
            }));
  }
}
