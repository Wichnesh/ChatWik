import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:demo_application/views/home_screen/Screens/chat_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class people extends StatelessWidget {
  people({Key? key}) : super(key: key);

  var currentuser = FirebaseAuth.instance.currentUser?.uid;

  void callChatDetailScreen(BuildContext context, String name, String id) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ChatDetail(
                  friendid: name,
                  friendName: id,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where('id', isNotEqualTo: currentuser)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('something went Wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Loading'),
            );
          }

          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text("people"),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        Map<String, dynamic>? data =
                            document.data()! as Map<String, dynamic>;
                        return CupertinoListTile(
                          onTap: () => callChatDetailScreen(
                              context, data['name'], data['id']),
                          title: Text(data['name']),
                          subtitle: Text(data['status']),
                        );
                      },
                    ).toList(),
                  ),
                )
              ],
            );
          }
          return Container();
        });
  }
}
