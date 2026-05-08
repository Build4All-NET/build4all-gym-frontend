import 'dart:async';

import 'package:android_pip/actions/pip_action.dart';
import 'package:android_pip/actions/pip_actions_layout.dart';
import 'package:android_pip/android_pip.dart';
import 'package:android_pip/pip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/config/env.dart';
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

class _TrainerVideoPlayerScreenState extends State<TrainerVideoPlayerScreen>
    with WidgetsBindingObserver {
  late final VideoPlayerController _controller;

  final AndroidPIP _pip = AndroidPIP();

  bool _isLoading = true;
  String? _errorMessage;

  // Normal screen controls.
  // Hidden at first. Tap screen -> show for 3 seconds.
  bool _showControls = false;

  // Used before entering PiP.
  // When true, we remove AppBar/title/Flutter controls so PiP captures only video.
  bool _isPipView = false;

  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    final url = _resolveVideoUrl(widget.video.videoUrl);
    debugPrint('VIDEO PLAYER URL: $url');

    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controller.addListener(_onControllerChanged);

    _initializeVideo();
  }

  void _onControllerChanged() {
    final error = _controller.value.errorDescription;

    if (error != null) {
      debugPrint('VIDEO PLAYER INTERNAL ERROR: $error');
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When user opens app again from PiP, restore normal screen.
    if (state == AppLifecycleState.resumed && _isPipView) {
      setState(() {
        _isPipView = false;
        _showControls = false;
      });
    }
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize().timeout(
        const Duration(seconds: 12),
      );

      await _controller.play();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _showControls = false;
      });

      // Keep PiP play/pause icon in sync with actual video state.
      _pip.setIsPlaying(true);
    } catch (e) {
      debugPrint('VIDEO PLAYER ERROR: $e');

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      setState(() {
        _isLoading = false;
        _errorMessage = l10n.ptTrainingVideosOpenError;
      });
    }
  }

  String _resolveVideoUrl(String rawUrl) {
    final url = rawUrl.trim();

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    if (url.startsWith('/')) {
      return '${Env.apiProjectBaseUrl}$url';
    }

    return '${Env.apiProjectBaseUrl}/$url';
  }

  void _toggleControls() {
    if (_isPipView) return;

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
    if (!mounted || _isPipView) return;

    setState(() {
      _showControls = true;
    });

    _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();

    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      setState(() {
        _showControls = false;
      });
    });
  }

  // One reusable function for play/pause.
  // Called from:
  // - big Flutter button
  // - PiP action callback
  void _togglePlayPause() {
    if (!_controller.value.isInitialized) return;

    if (_controller.value.isPlaying) {
      _pauseVideo();
    } else {
      _playVideo();
    }

    _showControlsForThreeSeconds();
  }

  void _playVideo() {
    if (!_controller.value.isInitialized) return;

    _controller.play();

    // Update Android PiP play/pause icon state.
    _pip.setIsPlaying(true);
  }

  void _pauseVideo() {
    if (!_controller.value.isInitialized) return;

    _controller.pause();

    // Update Android PiP play/pause icon state.
    _pip.setIsPlaying(false);
  }

  // One reusable seek function.
  // Used by:
  // - Flutter 10s buttons
  // - PiP previous/next actions
  Future<void> _seekBySeconds(int seconds) async {
    await _seekBy(Duration(seconds: seconds));
    _showControlsForThreeSeconds();
  }

  Future<void> _seekBy(Duration offset) async {
    if (!_controller.value.isInitialized) return;

    final currentPosition = _controller.value.position;
    final videoDuration = _controller.value.duration;

    var targetPosition = currentPosition + offset;

    if (targetPosition < Duration.zero) {
      targetPosition = Duration.zero;
    }

    if (targetPosition > videoDuration) {
      targetPosition = videoDuration;
    }

    await _controller.seekTo(targetPosition);
  }

  // This handles the Android PiP small-window actions.
  //
  // media_with_seek_10 maps actions to:
  // - play
  // - pause
  // - previous / rewind
  // - next / forward
  void _handlePipAction(PipAction action) {
    debugPrint('PIP ACTION: ${action.name}');

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
    final isAvailable = await AndroidPIP.isPipAvailable;

    if (!mounted) return;

    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Picture-in-Picture is not available on this device.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _hideControlsTimer?.cancel();

    // Tell PiP which icon state to show.
    _pip.setIsPlaying(_controller.value.isPlaying);

    // Hide AppBar/title/Flutter controls before Android captures the Activity.
    setState(() {
      _isPipView = true;
      _showControls = false;
    });

    // Wait one frame so Android captures video-only UI.
    await Future.delayed(const Duration(milliseconds: 250));

    await _pip.enterPipMode(
      aspectRatio: const [16, 9],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _hideControlsTimer?.cancel();
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return PipWidget(
      // This gives Android PiP small-window controls.
      // It is the preset that includes media controls with seek 10 support.
      pipLayout: PipActionsLayout.media_with_seek_10,

      // Callback fired when user presses PiP buttons.
      onPipAction: _handlePipAction,

      onPipEntered: () {
        debugPrint('Entered PiP');
      },

      onPipMaximised: () {
        debugPrint('Returned from PiP');

        if (mounted) {
          setState(() {
            _isPipView = false;
            _showControls = false;
          });
        }
      },

      onPipExited: () {
        debugPrint('Exited PiP');

        if (mounted) {
          setState(() {
            _isPipView = false;
            _showControls = false;
          });
        }
      },

      // What Android shows inside the small PiP window:
      // video only, no title, no Flutter buttons.
      pipChild: _buildVideoOnlyForPip(),

      // Normal app UI.
      child: Scaffold(
        backgroundColor: tokens.colors.label,
        appBar: _isPipView
            ? null
            : AppBar(
          backgroundColor: tokens.colors.label,
          foregroundColor: tokens.colors.surface,
          elevation: 0.0,
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
          child: _isPipView ? _buildVideoOnlyForPip() : _buildBody(tokens),
        ),
      ),
    );
  }

  Widget _buildVideoOnlyForPip() {
    if (!_controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    final videoSize = _controller.value.size;

    return ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: videoSize.width,
            height: videoSize.height,
            child: VideoPlayer(_controller),
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

    if (!_controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
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
                size: 38.0,
                iconSize: 22.0,
                onPressed: _enterPictureInPicture,
              ),
            ),

          if (_showControls)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerControlButton(
                  icon: Icons.replay_10_rounded,
                  size: 46.0,
                  iconSize: 30.0,
                  onPressed: () => _seekBySeconds(-10),
                ),
                SizedBox(width: tokens.spacing.md),
                PlayerControlButton(
                  icon: _controller.value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 58.0,
                  iconSize: 42.0,
                  onPressed: _togglePlayPause,
                ),
                SizedBox(width: tokens.spacing.md),
                PlayerControlButton(
                  icon: Icons.forward_10_rounded,
                  size: 46.0,
                  iconSize: 30.0,
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
                controller: _controller,
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
    this.size = 46.0,
    this.iconSize = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2.0),
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
        SizedBox(width: tokens.spacing.sm),
        Expanded(
          child: VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: tokens.colors.surface,
              bufferedColor: tokens.colors.muted,
              backgroundColor: tokens.colors.surface.withOpacity(0.25),
            ),
          ),
        ),
        SizedBox(width: tokens.spacing.sm),
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