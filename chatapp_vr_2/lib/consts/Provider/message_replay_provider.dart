import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../message_enum.dart';

class MessageReplay {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReplay(
      {required this.message, required this.isMe, required this.messageEnum});
}

final messageReplayProvider = StateProvider<MessageReplay?>((ref) => null);
