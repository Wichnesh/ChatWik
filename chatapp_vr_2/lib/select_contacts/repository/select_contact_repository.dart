import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_application/Model/User_model.dart';
import 'package:demo_application/Snackbar/snackbarWidget.dart';
import 'package:demo_application/consts/consts.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

import '../../views/home_screen/Screens/chats/screen/MobileChatScreen.dart';
import '../../views/home_screen/Screens/chats/screen/chat_details.dart';

final selectContactsRespositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  late final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      print(e.toString());
    }
    return contacts;
  }

  void callChatDetailScreen(BuildContext context, String name, String id) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ChatDetail(
                  friendUid: id,
                  friendName: name,
                )));
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var usercollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in usercollection.docs) {
        var userData = UserModel.fromMap(document.data()!);
        String selectedPhoneNum =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (selectedPhoneNum == userData.phone) {
          isFound = true;
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name': userData.name,
            'id': userData.id,
          });
        }
      }
      if (!isFound) {
        showCupertinoSnackBar(
            context: context,
            message: 'This number does not exist in this application ');
      }
    } catch (e) {
      showCupertinoSnackBar(context: context, message: e.toString());
    }
  }
}
