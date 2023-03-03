import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/helpers/exit_app_helper.dart';
import 'package:online_chat/pages/write_message_page.dart';
import 'package:online_chat/view_model/people_tab_page_view_model.dart';
import 'package:provider/provider.dart';
import '../model/m_user.dart';
import '../services/auth_service.dart';

class PeopleTabPage extends StatefulWidget {
  @override
  State<PeopleTabPage> createState() => _PeopleTabPageState();
}

class _PeopleTabPageState extends State<PeopleTabPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
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
                await Provider.of<PeopleTabPageViewModel>(context,listen: false).signOut();
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

// Widget _buildBody(
//     List<MUser> allUserList, MUser sessionOwner, PageStatus pageStatus) {
//   switch (pageStatus) {
//     case PageStatus.idle:
//       return Container();
//     case PageStatus.firstPageLoading:
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     case PageStatus.firstPageLoaded:
//       return _buildListViewBuilder(allUserList, sessionOwner);
//     case PageStatus.firstPageNoItemsFound:
//       return Container();
//     case PageStatus.newPageLoading:
//       print("new page loading calisiyor");
//       return Stack(
//         children: [
//           _buildListViewBuilder(allUserList, sessionOwner),
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: Center(child: CircularProgressIndicator())),
//         ],
//       );
//     case PageStatus.newPageLoaded:
//       print("new paged loaded");
//       print("liste uzunlugu: ${allUserList.length}");
//       return _buildListViewBuilder(allUserList, sessionOwner);
//     case PageStatus.newPageNoItemsFound:
//       return _buildListViewBuilder(allUserList, sessionOwner);
//     case PageStatus.loadingError:
//       return Container();
//   }
// }

// Widget _buildListViewBuilder(List<MUser> allUserList, MUser sessionOwner) {
//   return Column(
//     children: [
//       Expanded(
//         child: ListView.builder(
//           controller: _scrollController,
//           itemCount: allUserList.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: EdgeInsets.symmetric(vertical: 17),
//               child: Card(
//                 child: ListTile(
//                   onTap: () {
//                     Navigator.of(context, rootNavigator: true)
//                         .push(MaterialPageRoute(
//                             builder: (context) => WriteMessagePage(
//                                   receiverUser: allUserList[index],
//                                   sessionOwnerUserId: sessionOwner.userId!,
//                                 )));
//                   },
//                   title: Text("${allUserList[index].displayName}"),
//                   trailing: Icon(Icons.chevron_right),
//                   leading: Image.network("${allUserList[index].photoUrl}"),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       if (Provider.of<PeopleTabPageViewModel>(context).pageStatus ==
//           PageStatus.newPageLoading)
//         CircularProgressIndicator()
//     ],
//   );
// }
}
