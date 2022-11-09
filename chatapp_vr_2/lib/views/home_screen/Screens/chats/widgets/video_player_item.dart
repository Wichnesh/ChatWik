import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../consts/consts.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController _videocontroller;
  bool isPlay = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videocontroller = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        _videocontroller.setVolume(1);
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(_videocontroller),
          Align(
            alignment: Alignment.center,
            child: CupertinoButton(
                onPressed: () {
                  if (isPlay) {
                    _videocontroller.pause();
                  } else {
                    _videocontroller.play();
                  }
                  setState(() {
                    isPlay = !isPlay;
                  });
                },
                child: Icon(isPlay ? Icons.pause_circle : Icons.play_circle)),
          )
        ],
      ),
    );
  }
}
