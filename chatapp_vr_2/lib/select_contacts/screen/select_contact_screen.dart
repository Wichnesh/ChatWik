import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:demo_application/consts/consts.dart';
import 'package:demo_application/error.dart';
import 'package:demo_application/loader.dart';
import 'package:demo_application/select_contacts/controller/select_contact_controller.dart';
import 'package:demo_application/views/home_screen/Screens/chats/screen/MobileChatScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactScreen({Key? key}) : super(key: key);
  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
        middle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Select Contacts',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Contacts : ... ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
      child: SafeArea(
        child: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
                  itemCount: contactList!.length,
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    return CupertinoListTile(
                      onTap: () => selectContact(ref, contact, context),
                      title: Text(
                        contact.displayName,
                      ),
                    );
                  },
                ),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader()),
      ),
    );
  }
}
