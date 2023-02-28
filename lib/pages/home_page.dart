import 'package:flutter/material.dart';
import 'package:online_chat/pages/chat_tab_page.dart';
import 'package:online_chat/pages/my_custom_nav_bar.dart';
import 'package:online_chat/pages/people_tab_page.dart';
import 'package:online_chat/pages/profile_tab_page.dart';
import 'package:online_chat/view_model/people_tab_page_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab=TabItem.People;
  Widget _buildPage(TabItem tabItem){
    switch(tabItem){
      case TabItem.Profile:
        return ProfileTabPage();
      case TabItem.People:
        return Provider<PeopleTabPageViewModel>(create: (context)=>PeopleTabPageViewModel(),child: PeopleTabPage(),);
      case TabItem.Chat:
        return ChatTabPage();
    }
  }
  Map<TabItem,GlobalKey<NavigatorState>>navigatorKeys={
    TabItem.People:GlobalKey<NavigatorState>(),
    TabItem.Chat:GlobalKey<NavigatorState>(),
    TabItem.Profile:GlobalKey<NavigatorState>()
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        var result= await navigatorKeys[_currentTab]?.currentState?.maybePop(context);
        var reverseResult=!result!;
        print("anin degeri:${!result!}");
        return reverseResult;
      },
      child: MyCustomNavigationBar(
        navigatorKeys: navigatorKeys,
        buildPage: _buildPage,
        currentTab: _currentTab,onSelected: (TabItem secilenTab){
        setState(() {
          _currentTab=secilenTab;
        });
        print("Secili tab:${secilenTab}");
      },),
    );
  }
}
