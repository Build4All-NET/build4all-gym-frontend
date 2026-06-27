import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../core/network/globals.dart' as g;
import '../../../../auth/data/services/admin_token_store.dart';
import '../../../../auth/data/services/auth_token_store.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _controller;
  YoutubePlayerController? _youtubeController;

  bool _loading = true;
  String? _error;
  bool _showControls = true;
  bool _isFullscreen = false;
  bool _isYoutubeVideo = false;

  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<String?> _resolveToken() async {
    final runtimeToken = g.readAuthToken().trim();

    if (runtimeToken.isNotEmpty) {
      if (runtimeToken.toLowerCase().startsWith('bearer ')) {
        return runtimeToken.substring(7).trim();
      }

      return runtimeToken;
    }

    final adminToken =
        (await const AdminTokenStore().getToken())?.trim() ?? '';

    if (adminToken.isNotEmpty) {
      return adminToken;
    }

    final authToken =
        (await const AuthTokenStore().getToken())?.trim() ?? '';

    if (authToken.isNotEmpty) {
      return authToken;
    }

    return null;
  }

  Future<void> _initializeVideo() async {
    try {
      final rawUrl = widget.videoUrl.trim();

      if (rawUrl.isEmpty) {
        throw Exception('Video URL is empty.');
      }

      debugPrint('ADMIN RAW VIDEO URL: $rawUrl');

      /*
       * Detect YouTube links.
       *
       * Supported examples:
       * https://youtu.be/VIDEO_ID
       * https://www.youtube.com/watch?v=VIDEO_ID
       * https://youtube.com/shorts/VIDEO_ID
       */
      final youtubeId = YoutubePlayer.convertUrlToId(rawUrl);

      if (youtubeId != null && youtubeId.isNotEmpty) {
        debugPrint('ADMIN VIDEO TYPE: YOUTUBE');
        debugPrint('ADMIN YOUTUBE ID: $youtubeId');

        _isYoutubeVideo = true;

        _youtubeController = YoutubePlayerController(
          initialVideoId: youtubeId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: true,
            controlsVisibleAtStart: true,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
          ),
        );

        if (!mounted) return;

        setState(() {
          _loading = false;
          _error = null;
        });

        return;
      }

      /*
       * If it is not a YouTube URL, treat it as an uploaded video.
       */
      final fullUrl = g.resolveUrl(rawUrl);

      debugPrint('ADMIN VIDEO TYPE: UPLOADED');
      debugPrint('ADMIN RESOLVED VIDEO URL: $fullUrl');

      final token = await _resolveToken();

      final headers = <String, String>{
        'Accept': 'video/*,*/*',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(fullUrl),
        httpHeaders: headers,
      );

      _controller = controller;

      controller.addListener(_onVideoUpdate);

      await controller.initialize().timeout(
        const Duration(seconds: 20),
      );

      await controller.play();

      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = null;
      });

      _scheduleHide();
    } catch (error) {
      debugPrint('ADMIN VIDEO PLAYER ERROR: $error');

      debugPrint(
        'ADMIN VIDEO INTERNAL ERROR: '
            '${_controller?.value.errorDescription}',
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  void _onVideoUpdate() {
    final internalError = _controller?.value.errorDescription;

    if (internalError != null) {
      debugPrint('ADMIN VIDEO INTERNAL ERROR: $internalError');
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _scheduleHide() {
    _hideTimer?.cancel();

    _hideTimer = Timer(
      const Duration(seconds: 3),
          () {
        if (!mounted) return;

        if (_controller?.value.isPlaying ?? false) {
          setState(() {
            _showControls = false;
          });
        }
      },
    );
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _scheduleHide();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _togglePlay() {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (controller.value.isPlaying) {
      controller.pause();

      _hideTimer?.cancel();

      setState(() {
        _showControls = true;
      });
    } else {
      controller.play();
      _scheduleHide();
    }
  }

  Future<void> _seek(Duration requestedPosition) async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    final duration = controller.value.duration;

    var targetPosition = requestedPosition;

    if (targetPosition < Duration.zero) {
      targetPosition = Duration.zero;
    }

    if (targetPosition > duration) {
      targetPosition = duration;
    }

    await controller.seekTo(targetPosition);

    _scheduleHide();
  }

  Future<void> _toggleFullscreen() async {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      );
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      );
    }
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours;

    final minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _hideTimer?.cancel();

    _controller?.removeListener(_onVideoUpdate);
    _controller?.dispose();

    _youtubeController?.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullscreen
          ? null
          : AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    /*
     * YouTube player branch.
     */
    if (_isYoutubeVideo && _youtubeController != null) {
      return Center(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            progressColors: const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
            ),
          ),
          builder: (context, player) {
            return player;
          },
        ),
      );
    }

    /*
     * Uploaded video branch.
     */
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: Text(
          'Video could not be initialized.',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      );
    }

    return _buildUploadedVideoPlayer(controller);
  }

  Widget _buildUploadedVideoPlayer(
      VideoPlayerController controller,
      ) {
    final position = controller.value.position;
    final duration = controller.value.duration;

    final progress = duration.inMilliseconds > 0
        ? (position.inMilliseconds / duration.inMilliseconds)
        .clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !_showControls,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black87,
                    ],
                    stops: [
                      0.0,
                      0.3,
                      0.7,
                      1.0,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFullscreenTopBar(),
                    _buildCenterPlayButton(controller),
                    _buildBottomControls(
                      position: position,
                      duration: duration,
                      progress: progress,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.value.isBuffering)
            const CircularProgressIndicator(
              color: Colors.white54,
            ),
        ],
      ),
    );
  }

  Widget _buildFullscreenTopBar() {
    if (!_isFullscreen) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        0,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: _toggleFullscreen,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPlayButton(
      VideoPlayerController controller,
      ) {
    return GestureDetector(
      onTap: _togglePlay,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          controller.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildBottomControls({
    required Duration position,
    required Duration duration,
    required double progress,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        0,
        12,
        8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white30,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 6,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 14,
              ),
              trackHeight: 3,
            ),
            child: Slider(
              value: progress,
              onChanged: (value) {
                final targetPosition = Duration(
                  milliseconds:
                  (value * duration.inMilliseconds).toInt(),
                );

                _seek(targetPosition);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: Row(
              children: [
                Text(
                  _formatTime(position),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '/',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTime(duration),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.replay_10,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    _seek(
                      position - const Duration(seconds: 10),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(
                    Icons.forward_10,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    _seek(
                      position + const Duration(seconds: 10),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(
                    _isFullscreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: _toggleFullscreen,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}