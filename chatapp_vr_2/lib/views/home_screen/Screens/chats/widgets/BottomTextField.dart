import 'dart:io';
import 'package:demo_application/Snackbar/snackbarMaterialApp.dart';
import 'package:demo_application/consts/message_enum.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../consts/consts.dart';
import '../controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({
    Key? key,
    required this.receiverUserId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  final TextEditingController _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUserId, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  // void hideEmojiContainer() {
  //   setState(() {
  //     isShowEmojiContainer = false;
  //   });
  // }
  //
  // void showEmojiContainer() {
  //   setState(() {
  //     isShowEmojiContainer = true;
  //   });
  // }
  // void showKeyboard() => focusNode.requestFocus();
  // void hideKeyboard() => focusNode.unfocus();
  // void toggleEmojiKeyboardContainer() {
  //   if (!isShowEmojiContainer) {
  //     showKeyboard();
  //     hideEmojiContainer();
  //   } else {
  //     hideKeyboard();
  //     showEmojiContainer();
  //   }
  // }
  // void selectGIF() async {
  //   final gif = await pickGIF(context);
  //   if (gif != null) {
  //     ref
  //         .read(chatControllerProvider)
  //         .sendGIFMessage(context, gif.url, widget.receiverUserId);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: CupertinoTextField(
                  focusNode: focusNode,
                  controller: _messageController,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
                  },
                  placeholder: 'Message',
                  prefix: Padding(
                    padding: const EdgeInsets.all(0),
                    child: SizedBox(
                      width: 64,
                      child: Row(
                        children: [
                          CupertinoButton(
                            minSize: double.minPositive,
                            padding: const EdgeInsets.all(5),
                            onPressed: () {
                              setState(() {
                                isShowEmojiContainer = !isShowEmojiContainer;
                              });
                            },
                            child: const Icon(
                              Icons.emoji_emotions,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          CupertinoButton(
                              minSize: double.minPositive,
                              padding: const EdgeInsets.all(0),
                              onPressed: () {},
                              child: const Icon(Icons.gif))
                        ],
                      ),
                    ),
                  ),
                  suffix: SizedBox(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                            minSize: double.minPositive,
                            padding: const EdgeInsets.all(0),
                            onPressed: selectVideo,
                            child: const Icon(
                              Icons.attach_file,
                              size: 20,
                            )),
                        CupertinoButton(
                          minSize: double.minPositive,
                          padding: const EdgeInsets.all(0),
                          child: const Icon(
                            Icons.currency_rupee_rounded,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                        CupertinoButton(
                          minSize: double.minPositive,
                          padding: const EdgeInsets.all(5),
                          onPressed: selectImage,
                          child: const Icon(
                            CupertinoIcons.camera,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                right: 10,
                left: 3,
              ),
              child: CircleAvatar(
                radius: 18,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: sendTextMessage,
                    child: Icon(
                      isShowSendButton
                          ? Icons.send
                          : isRecording
                              ? Icons.close
                              : Icons.mic,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Offstage(
          offstage: !isShowEmojiContainer,
          child: SizedBox(
              height: 250,
              child: EmojiPicker(
                textEditingController: _messageController,
                onEmojiSelected: (category, emoji) {
                  if (!isShowSendButton) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  }
                },
              )),
        ),
      ],
    );
  }
}
