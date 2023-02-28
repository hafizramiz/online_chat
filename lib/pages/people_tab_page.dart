import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/helpers/exit_app_helper.dart';
import 'package:online_chat/pages/write_message_page.dart';
import 'package:online_chat/view_model/people_tab_page_view_model.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';

class PeopleTabPage extends StatefulWidget {
  @override
  State<PeopleTabPage> createState() => _PeopleTabPageState();
}

class _PeopleTabPageState extends State<PeopleTabPage> {
  late MUser currentUser;

  @override
  void initState() {
    currentUser=Provider.of<PeopleTabPageViewModel>(context,listen: false).getCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('People'),
          actions: [
            TextButton(
                onPressed: () async {
                  final logout = await ExitAppHelper.exitApp(context);
                  print("logout degeri : ${logout}");
                  if (logout == true) {
                    try {
                      await Provider.of<PeopleTabPageViewModel>(context, listen: false)
                          .signOut;
                      Navigator.of(context, rootNavigator: true)
                          .popUntil(ModalRoute.withName("/loginPage"));
                    } catch (error) {
                      print("hata: ${error}");
                    }
                  }
                },
                child: Text(
                  "Cikis",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
            Provider.of<PeopleTabPageViewModel>(context, listen: false).getAllUsers(),
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
                          trailing: Icon(Icons.chevron_right),
                          leading:
                          Image.network("${allUserList[index].photoUrl}"),

                        );
                      });
                }
              }
            }));
  }
}
