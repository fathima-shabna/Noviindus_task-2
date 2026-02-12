import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class FeedVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final bool autoPlay;

  const FeedVideoPlayer({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.autoPlay = false,
  });

  @override
  State<FeedVideoPlayer> createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay,
      looping: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      showControls: true,
      optionsTranslation: OptionsTranslation(
        playbackSpeedButtonText: 'Speed',
        subtitlesButtonText: 'Subtitles',
        cancelButtonText: 'Cancel',
      ),
      placeholder: widget.thumbnailUrl != null
          ? Image.network(
              widget.thumbnailUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
            )
          : Container(color: Colors.black),
      materialProgressColors: ChewieProgressColors(
        playedColor: const Color(0xFFC60000),
        handleColor: const Color(0xFFC60000),
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white.withOpacity(0.3),
      ),
    );

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _chewieController == null) {
      return widget.thumbnailUrl != null
          ? Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  widget.thumbnailUrl!,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                const CircularProgressIndicator(color: Color(0xFFC60000)),
              ],
            )
          : Container(
              height: 200,
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFC60000)),
              ),
            );
    }

    return AspectRatio(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}
