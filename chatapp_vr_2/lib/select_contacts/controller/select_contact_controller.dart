import 'package:demo_application/consts/consts.dart';
import 'package:demo_application/select_contacts/repository/select_contact_repository.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:riverpod/riverpod.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactsRespositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactRespository = ref.watch(selectContactsRespositoryProvider);
  return SelectContactController(
    ref: ref,
    selectContactRepository: selectContactRespository,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController(
      {required this.ref, required this.selectContactRepository});

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactRepository.selectContact(selectedContact, context);
  }
}
