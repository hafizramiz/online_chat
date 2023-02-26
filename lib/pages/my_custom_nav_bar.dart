import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_chat/pages/profile_tab_page.dart';

class MyCustomNavigationBar extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem>onSelected;
  final Function buildPage;
  const MyCustomNavigationBar({Key? key, required this.currentTab, required this.onSelected, required this.buildPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [

            _buildBottomNavigationBarItem(TabItem.People),
            _buildBottomNavigationBarItem(TabItem.Chat),
            _buildBottomNavigationBarItem(TabItem.Profile),
          ],
          onTap: (index){
            onSelected(TabItem.values[index]);
          },
        ),
        tabBuilder: (BuildContext context, int index){
          return CupertinoTabView(

            builder: (context){
              print("Build calisti");
             return buildPage(TabItem.values[index]);
            },
          );
        });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(TabItem tabItem){
    switch(tabItem){
      case TabItem.Profile:
          return BottomNavigationBarItem(icon: Icon(Icons.person));
      case TabItem.People:
        return BottomNavigationBarItem(icon: Icon(Icons.people));
      case TabItem.Chat:
        return BottomNavigationBarItem(icon: Icon(Icons.chat));
    }
  }
}

enum TabItem{People,Chat,Profile}
