import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_application/consts/message_enum.dart';
import 'package:demo_application/views/home_screen/Screens/chats/widgets/video_player_item.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../consts/consts.dart';

class DisplayTIG extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTIG({Key? key, required this.type, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(
                videoUrl: message,
              )
            : type == MessageEnum.audio
                ? StatefulBuilder(builder: (context, setState) {
                    return IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                        ),
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_circle),
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            await audioPlayer.play(UrlSource(message));
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        });
                  })
                : type == MessageEnum.gif
                    ? CachedNetworkImage(
                        imageUrl: message,
                      )
                    : CachedNetworkImage(imageUrl: message);
  }
}
