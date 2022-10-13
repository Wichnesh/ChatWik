import 'package:demo_application/views/home_screen/Screens/Calls.dart';
import 'package:demo_application/views/home_screen/Screens/Settings.dart';
import 'package:demo_application/views/home_screen/Screens/chats.dart';
import 'package:flutter/cupertino.dart';
import 'Screens/People.dart';
import 'Screens/chat_details.dart';
import 'Screens/select_contact_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      theme: CupertinoThemeData(brightness: Brightness.light),
    );
  }
}

class Homepage extends StatelessWidget {
  Homepage({Key? key}) : super(key: key);
  var screens = [Chats(), calls(), people(), Settings(), SelectContactScreen()];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
          ),
          BottomNavigationBarItem(
            label: "Calls",
            icon: Icon(CupertinoIcons.phone),
          ),
          BottomNavigationBarItem(
            label: "People",
            icon: Icon(CupertinoIcons.person_alt_circle),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(CupertinoIcons.settings_solid),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return screens[index];
      },
    ));
  }
}
