import 'dart:async';

import 'package:android_pip/actions/pip_action.dart';
import 'package:android_pip/actions/pip_actions_layout.dart';
import 'package:android_pip/android_pip.dart';
import 'package:android_pip/pip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../core/network/globals.dart' as g;
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/trainer_video_entity.dart';

class TrainerVideoPlayerScreen extends StatefulWidget {
  final TrainerVideoEntity video;

  const TrainerVideoPlayerScreen({
    super.key,
    required this.video,
  });

  @override
  State<TrainerVideoPlayerScreen> createState() =>
      _TrainerVideoPlayerScreenState();
}

class _TrainerVideoPlayerScreenState
    extends State<TrainerVideoPlayerScreen>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  YoutubePlayerController? _youtubeController;

  final AndroidPIP _pip = AndroidPIP();

  bool _isLoading = true;
  bool _isYoutubeVideo = false;
  bool _showControls = false;
  bool _isPipView = false;

  String? _errorMessage;

  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final rawUrl = widget.video.videoUrl.trim();

    debugPrint('MEMBER RAW VIDEO URL: $rawUrl');

    if (rawUrl.isEmpty) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
            AppLocalizations.of(context)!.ptTrainingVideosOpenError;
      });

      return;
    }

    final youtubeId = YoutubePlayer.convertUrlToId(rawUrl);

    if (youtubeId != null && youtubeId.isNotEmpty) {
      debugPrint('MEMBER VIDEO TYPE: YOUTUBE');
      debugPrint('MEMBER YOUTUBE ID: $youtubeId');

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
        _isLoading = false;
        _errorMessage = null;
      });

      return;
    }

    final resolvedUrl = g.resolveUrl(rawUrl);

    debugPrint('MEMBER VIDEO TYPE: UPLOADED');
    debugPrint('MEMBER RESOLVED VIDEO URL: $resolvedUrl');

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(resolvedUrl),
      httpHeaders: const {
        'Accept': 'video/*,*/*',
      },
    );

    _controller = controller;

    controller.addListener(_onControllerChanged);

    await _initializeUploadedVideo(controller);
  }

  Future<void> _initializeUploadedVideo(
      VideoPlayerController controller,
      ) async {
    try {
      await controller.initialize().timeout(
        const Duration(seconds: 20),
      );

      await controller.play();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = null;
        _showControls = false;
      });

      _pip.setIsPlaying(true);
    } catch (error) {
      debugPrint('MEMBER VIDEO PLAYER ERROR: $error');
      debugPrint(
        'MEMBER VIDEO INTERNAL ERROR: '
            '${controller.value.errorDescription}',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
            AppLocalizations.of(context)!.ptTrainingVideosOpenError;
      });
    }
  }

  void _onControllerChanged() {
    final controller = _controller;

    if (controller == null) return;

    final error = controller.value.errorDescription;

    if (error != null) {
      debugPrint('MEMBER VIDEO INTERNAL ERROR: $error');
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isPipView) {
      setState(() {
        _isPipView = false;
        _showControls = false;
      });
    }
  }

  void _toggleControls() {
    if (_isPipView || _isYoutubeVideo) return;

    if (_showControls) {
      setState(() {
        _showControls = false;
      });

      _hideControlsTimer?.cancel();

      return;
    }

    _showControlsForThreeSeconds();
  }

  void _showControlsForThreeSeconds() {
    if (!mounted || _isPipView || _isYoutubeVideo) return;

    setState(() {
      _showControls = true;
    });

    _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();

    _hideControlsTimer = Timer(
      const Duration(seconds: 3),
          () {
        if (!mounted) return;

        setState(() {
          _showControls = false;
        });
      },
    );
  }

  void _togglePlayPause() {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (controller.value.isPlaying) {
      _pauseVideo();
    } else {
      _playVideo();
    }

    _showControlsForThreeSeconds();
  }

  void _playVideo() {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    controller.play();

    _pip.setIsPlaying(true);
  }

  void _pauseVideo() {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    controller.pause();

    _pip.setIsPlaying(false);
  }

  Future<void> _seekBySeconds(int seconds) async {
    await _seekBy(
      Duration(seconds: seconds),
    );

    _showControlsForThreeSeconds();
  }

  Future<void> _seekBy(Duration offset) async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    final currentPosition = controller.value.position;
    final videoDuration = controller.value.duration;

    var targetPosition = currentPosition + offset;

    if (targetPosition < Duration.zero) {
      targetPosition = Duration.zero;
    }

    if (targetPosition > videoDuration) {
      targetPosition = videoDuration;
    }

    await controller.seekTo(targetPosition);
  }

  void _handlePipAction(PipAction action) {
    if (_isYoutubeVideo) return;

    debugPrint('MEMBER PIP ACTION: ${action.name}');

    switch (action) {
      case PipAction.play:
        _playVideo();
        break;

      case PipAction.pause:
        _pauseVideo();
        break;

      case PipAction.previous:
        _seekBySeconds(-10);
        break;

      case PipAction.next:
        _seekBySeconds(10);
        break;

      default:
        break;
    }
  }

  Future<void> _enterPictureInPicture() async {
    if (_isYoutubeVideo) return;

    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    final isAvailable = await AndroidPIP.isPipAvailable;

    if (!mounted) return;

    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .ptTrainingVideosPipUnavailable,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    _hideControlsTimer?.cancel();

    _pip.setIsPlaying(controller.value.isPlaying);

    setState(() {
      _isPipView = true;
      _showControls = false;
    });

    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    await _pip.enterPipMode(
      aspectRatio: const [16, 9],
    );
  }

  String _formatDuration(Duration duration) {
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
      return '${hours.toString().padLeft(2, '0')}:'
          '$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _hideControlsTimer?.cancel();

    _controller?.removeListener(_onControllerChanged);
    _controller?.dispose();

    _youtubeController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return PipWidget(
      pipLayout: PipActionsLayout.media_with_seek_10,
      onPipAction: _handlePipAction,

      onPipEntered: () {
        debugPrint('MEMBER ENTERED PIP');
      },

      onPipMaximised: () {
        debugPrint('MEMBER RETURNED FROM PIP');

        if (mounted) {
          setState(() {
            _isPipView = false;
            _showControls = false;
          });
        }
      },

      onPipExited: () {
        debugPrint('MEMBER EXITED PIP');

        if (mounted) {
          setState(() {
            _isPipView = false;
            _showControls = false;
          });
        }
      },

      pipChild: _buildVideoOnlyForPip(),

      child: Scaffold(
        backgroundColor: tokens.colors.label,
        appBar: _isPipView
            ? null
            : AppBar(
          backgroundColor: tokens.colors.label,
          foregroundColor: tokens.colors.surface,
          elevation: 0,
          title: Text(
            widget.video.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.surface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Center(
          child: _isPipView
              ? _buildVideoOnlyForPip()
              : _buildBody(tokens),
        ),
      ),
    );
  }

  Widget _buildVideoOnlyForPip() {
    final controller = _controller;

    if (_isYoutubeVideo ||
        controller == null ||
        !controller.value.isInitialized) {
      return const ColoredBox(
        color: Colors.black,
      );
    }

    final videoSize = controller.value.size;

    return ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: videoSize.width,
            height: videoSize.height,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(dynamic tokens) {
    if (_isLoading) {
      return CircularProgressIndicator(
        color: tokens.colors.surface,
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: EdgeInsets.all(tokens.spacing.xl),
        child: Text(
          _errorMessage!,
          textAlign: TextAlign.center,
          style: tokens.typography.bodyMedium.copyWith(
            color: tokens.colors.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

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

    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),

          if (_showControls)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: tokens.colors.label.withOpacity(0.25),
                ),
              ),
            ),

          if (_showControls)
            Positioned(
              top: tokens.spacing.md,
              right: tokens.spacing.md,
              child: PlayerControlButton(
                icon: Icons.picture_in_picture_alt_rounded,
                size: 38,
                iconSize: 22,
                onPressed: _enterPictureInPicture,
              ),
            ),

          if (_showControls)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerControlButton(
                  icon: Icons.replay_10_rounded,
                  size: 46,
                  iconSize: 30,
                  onPressed: () => _seekBySeconds(-10),
                ),
                SizedBox(
                  width: tokens.spacing.md,
                ),
                PlayerControlButton(
                  icon: controller.value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 58,
                  iconSize: 42,
                  onPressed: _togglePlayPause,
                ),
                SizedBox(
                  width: tokens.spacing.md,
                ),
                PlayerControlButton(
                  icon: Icons.forward_10_rounded,
                  size: 46,
                  iconSize: 30,
                  onPressed: () => _seekBySeconds(10),
                ),
              ],
            ),

          if (_showControls)
            Positioned(
              left: tokens.spacing.md,
              right: tokens.spacing.md,
              bottom: tokens.spacing.md,
              child: VideoTimeBar(
                controller: controller,
                formatDuration: _formatDuration,
              ),
            ),
        ],
      ),
    );
  }
}

class PlayerControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;

  const PlayerControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 46,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: tokens.colors.label.withOpacity(0.60),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: tokens.colors.surface,
          size: iconSize,
        ),
      ),
    );
  }
}

class VideoTimeBar extends StatelessWidget {
  final VideoPlayerController controller;
  final String Function(Duration duration) formatDuration;

  const VideoTimeBar({
    super.key,
    required this.controller,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    final position = controller.value.position;
    final duration = controller.value.duration;

    return Row(
      children: [
        Text(
          formatDuration(position),
          style: tokens.typography.bodySmall.copyWith(
            color: tokens.colors.surface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          width: tokens.spacing.sm,
        ),
        Expanded(
          child: VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: tokens.colors.surface,
              bufferedColor: tokens.colors.muted,
              backgroundColor:
              tokens.colors.surface.withOpacity(0.25),
            ),
          ),
        ),
        SizedBox(
          width: tokens.spacing.sm,
        ),
        Text(
          formatDuration(duration),
          style: tokens.typography.bodySmall.copyWith(
            color: tokens.colors.surface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}