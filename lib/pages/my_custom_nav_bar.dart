import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomNavigationBar extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelected;
  final Function buildPage;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const MyCustomNavigationBar(
      {Key? key,
      required this.currentTab,
      required this.onSelected,
      required this.buildPage,
      required this.navigatorKeys})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.transparent,
            activeColor:Color(0xff5b61b9),
          inactiveColor: Colors.black87,
          items: [
            _buildBottomNavigationBarItem(TabItem.People),
            _buildBottomNavigationBarItem(TabItem.Chat),
            _buildBottomNavigationBarItem(TabItem.Profile),
          ],
          onTap: (index) {
            onSelected(TabItem.values[index]);
          },
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            navigatorKey: navigatorKeys[TabItem.values[index]],
            builder: (context) {
              return buildPage(TabItem.values[index]);
            },
          );
        });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.Profile:
        return BottomNavigationBarItem(
            icon: Icon(
          Icons.person,
          size: 40,
        ));

      case TabItem.People:
        return BottomNavigationBarItem(
            icon: Icon(
          Icons.people,
          size: 40,
        ));
      case TabItem.Chat:
        return BottomNavigationBarItem(
            icon: Icon(
          Icons.chat,
          size: 40,
        ));
    }
  }
}

enum TabItem { People, Chat, Profile }
