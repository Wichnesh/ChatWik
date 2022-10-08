import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';

class ChatDetail extends StatefulWidget {
  final friendid;
  final friendName;
  const ChatDetail({
    Key? key,
    required this.friendid,
    required this.friendName,
  }) : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState(friendid, friendName);
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final friendid;
  final friendName;
  final currentuserid = FirebaseAuth.instance.currentUser?.uid;
  var chatDocID;
  var _textController = new TextEditingController();
  _ChatDetailState(this.friendid, this.friendName);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chats
        .where('Users', isEqualTo: {friendid: null, currentuserid: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              chatDocID = querySnapshot.docs.single.id;
            } else {
              chats.add({
                'Users': {currentuserid: null, friendid: null}
              }).then((value) => {chatDocID = value});
            }
          },
        )
        .catchError((error) {});
  }

  void sendMessage(String msg) {}
  bool isSender(String friend) {
    return friend == currentuserid;
  }

  Alignment getAlignment(friend) {
    if (friend == currentuserid) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(chatDocID)
            .collection('messages')
            .orderBy('createdOn', descending: true)
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
            var data;
            return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  previousPageTitle: "Back",
                  middle: Text(friendName),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Icon(CupertinoIcons.phone),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView(
                        reverse: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          data = document.data()!;
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChatBubble(
                              clipper: ChatBubbleClipper6(
                                nipSize: 0,
                                radius: 0,
                                type: BubbleType.receiverBubble,
                              ),
                              alignment: getAlignment(data['id'].toString()),
                              margin: EdgeInsets.only(top: 20),
                              backGroundColor: isSender(data['id'].toString())
                                  ? Color(0xFF08C187)
                                  : Color(0xFFE7E7ED),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(data['msg'],
                                          style: TextStyle(
                                              color: isSender(
                                                      data['id'].toString())
                                                  ? Colors.white
                                                  : Colors.lightBlue),
                                          maxLines: 100,
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        data['createdOn'] == null
                                            ? DateTime.now().toString()
                                            : data['createdOn']
                                                .toDate()
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color:
                                                isSender(data['id'].toString())
                                                    ? Colors.white
                                                    : Colors.lightBlue),
                                      )
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: CupertinoTextField(
                            controller: _textController,
                          )),
                          CupertinoButton(
                              child: Icon(Icons.send_sharp),
                              onPressed: () =>
                                  sendMessage(_textController.text))
                        ],
                      )
                    ],
                  ),
                ));
          }
          return Container();
        });
  }
}
