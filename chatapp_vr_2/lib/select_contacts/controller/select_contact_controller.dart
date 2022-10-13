import 'package:demo_application/select_contacts/repository/select_contact_repository.dart';
import 'package:riverpod/riverpod.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactsRespositoryProvider);
  return selectContactRepository.getContacts();
});
