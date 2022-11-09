import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:demo_application/consts/consts.dart';
import 'package:demo_application/views/home_screen/Screens/chats/screen/MobileChatScreen.dart';
import 'package:demo_application/select_contacts/screen/select_contact_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class people extends StatelessWidget {
  people({Key? key}) : super(key: key);

  var currentuser = FirebaseAuth.instance.currentUser?.uid;

  // void callChatDetailScreen(BuildContext context, String name, String id) {
  //   Navigator.push(
  //       context,
  //       CupertinoPageRoute(
  //           builder: (context) => const MobileChatScreen(
  //                 Name: 'RRR',
  //                 Id: '12345',
  //               )));
  // }

  // void callContactScreen() {
  //   Navigator.push(context,
  //       CupertinoPageRoute(builder: (context) => SelectContactScreen()));
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where('id', isNotEqualTo: currentuser)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('something went Wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Loading'),
            );
          }

          if (snapshot.hasData) {
            return CupertinoPageScaffold(
                child: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  automaticallyImplyLeading: false,
                  largeTitle: const Text("people"),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(builder: (context) {
                        return const SelectContactScreen();
                      }));
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        Map<String, dynamic>? data =
                            document.data()! as Map<String, dynamic>;
                        return CupertinoListTile(
                          // onTap: () => callChatDetailScreen(
                          //     context, data['name'], data['id']),
                          title: Text(data['name']),
                          subtitle: Text(data['phone']),
                        );
                      },
                    ).toList(),
                  ),
                )
              ],
            ));
          }
          return Container();
        });
  }
}
