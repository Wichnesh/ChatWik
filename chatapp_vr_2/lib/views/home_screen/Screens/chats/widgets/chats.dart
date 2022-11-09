import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:demo_application/Model/chatcontact.dart';
import 'package:demo_application/select_contacts/screen/select_contact_screen.dart';
import 'package:demo_application/views/home_screen/Screens/chats/screen/MobileChatScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../controller/chat_controller.dart';

class Chats extends ConsumerWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
        automaticallyImplyLeading: false,
        largeTitle: const Text("Chats"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
              return const SelectContactScreen();
            }));
          },
        ),
      ),
      SliverFillRemaining(
        child: Scrollbar(
          child: StreamBuilder<List<ChatContact>>(
            stream: ref.watch(chatControllerProvider).chatContacts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var chatContactData = snapshot.data![index];
                    return CupertinoListTile(
                        onTap: () {
                          Navigator.pushNamed(
                              context, MobileChatScreen.routeName,
                              arguments: {
                                'name': chatContactData.name,
                                'id': chatContactData.contactId,
                              });
                        },
                        title: Text(
                          chatContactData.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(chatContactData.lastMessage),
                        ),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(chatContactData.profilePic),
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(chatContactData.timeSent),
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ));
                  });
            },
          ),
        ),
      )
    ]);
  }
}
