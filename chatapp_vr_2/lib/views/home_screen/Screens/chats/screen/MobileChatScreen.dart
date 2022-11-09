import 'package:demo_application/Model/User_model.dart';
import 'package:demo_application/consts/consts.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Auth_screen/controller&repository/Authcontroller.dart';
import '../widgets/BottomTextField.dart';
import '../widgets/chatlist.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String id;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: StreamBuilder<UserModel>(
              stream: ref.read(authControllerProvider).userDataById(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text(name),
                  );
                }
                return Column(
                  children: [
                    Text(name),
                    Text(
                      snapshot.data!.isOnline ? 'online' : 'offline',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ChatList(
                  receiverUserId: id,
                ),
              ),
              BottomChatField(
                receiverUserId: id,
              ),
            ],
          ),
        ));
  }
}
