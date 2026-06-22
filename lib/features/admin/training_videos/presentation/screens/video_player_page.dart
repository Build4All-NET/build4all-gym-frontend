import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../../../core/config/env.dart';
import '../../../../../core/network/globals.dart' as g;
import '../../../../auth/data/services/admin_token_store.dart';
import '../../../../auth/data/services/auth_token_store.dart';
import '../../../../../l10n/app_localizations.dart';

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

  bool _loading = true;
  String? _error;
  bool _showControls = true;
  bool _isFullscreen = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  // Mirrors AuthedHttpClient's token resolution: prefer the in-memory
  // runtime token (works for both admin and trainer/member sessions),
  // then fall back to the persisted stores.
  Future<String?> _resolveToken() async {
    final runtime = g.readAuthToken().trim();
    if (runtime.isNotEmpty) {
      return runtime.toLowerCase().startsWith('bearer ')
          ? runtime.substring(7).trim()
          : runtime;
    }
    final admin = (await const AdminTokenStore().getToken())?.trim() ?? '';
    if (admin.isNotEmpty) return admin;
    return (await const AuthTokenStore().getToken())?.trim();
  }

  Future<void> _initializeVideo() async {
    try {
      final projecturl = Env.apiProjectBaseUrl;
      final fullUrl = widget.videoUrl.startsWith('http')
          ? widget.videoUrl
          : '$projecturl${widget.videoUrl}';

      final token = await _resolveToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = AppLocalizations.of(context)!.trainingVideos_noAuthToken;
          });
        }
        return;
      }

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(fullUrl),
        httpHeaders: {
          'Authorization': 'Bearer $token',
          'Accept': '*/*',
        },
      );

      await _controller!.initialize();
      _controller!.addListener(_onVideoUpdate);
      await _controller!.play();
      setState(() => _loading = false);
      _scheduleHide();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _onVideoUpdate() {
    if (mounted) setState(() {});
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && (_controller?.value.isPlaying ?? false)) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _scheduleHide();
  }

  void _togglePlay() {
    if (_controller == null) return;
    if (_controller!.value.isPlaying) {
      _controller!.pause();
      setState(() => _showControls = true);
      _hideTimer?.cancel();
    } else {
      _controller!.play();
      _scheduleHide();
    }
  }

  void _seek(Duration position) {
    _controller?.seekTo(position);
    _scheduleHide();
  }

  Future<void> _toggleFullscreen() async {
    setState(() => _isFullscreen = !_isFullscreen);
    if (_isFullscreen) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.removeListener(_onVideoUpdate);
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
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
              title: Text(widget.title,
                  style: const TextStyle(color: Colors.white)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.redAccent, size: 48),
                        const SizedBox(height: 16),
                        Text(_error!,
                            style: const TextStyle(color: Colors.white70),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                )
              : _buildPlayer(),
    );
  }

  Widget _buildPlayer() {
    final ctrl = _controller!;
    final position = ctrl.value.position;
    final total = ctrl.value.duration;
    final progress = total.inMilliseconds > 0
        ? (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video
          Center(
            child: AspectRatio(
              aspectRatio: ctrl.value.aspectRatio,
              child: VideoPlayer(ctrl),
            ),
          ),
          // Controls overlay
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
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top bar title (fullscreen)
                    if (_isFullscreen)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () {
                                if (_isFullscreen) {
                                  _toggleFullscreen();
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(widget.title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    // Center play/pause
                    GestureDetector(
                      onTap: _togglePlay,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          ctrl.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),

                    // Bottom controls
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Progress slider
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.white30,
                              thumbColor: Colors.white,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14),
                              trackHeight: 3,
                            ),
                            child: Slider(
                              value: progress,
                              onChanged: (v) {
                                final target = Duration(
                                  milliseconds:
                                      (v * total.inMilliseconds).toInt(),
                                );
                                _seek(target);
                                setState(() {});
                              },
                            ),
                          ),
                          // Time row + fullscreen
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                Text(
                                  _formatTime(position),
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(width: 4),
                                const Text('/',
                                    style: TextStyle(
                                        color: Colors.white38, fontSize: 12)),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTime(total),
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                const Spacer(),
                                // Rewind 10s
                                IconButton(
                                  icon: const Icon(Icons.replay_10,
                                      color: Colors.white, size: 22),
                                  onPressed: () => _seek(
                                      position - const Duration(seconds: 10)),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 16),
                                // Forward 10s
                                IconButton(
                                  icon: const Icon(Icons.forward_10,
                                      color: Colors.white, size: 22),
                                  onPressed: () => _seek(
                                      position + const Duration(seconds: 10)),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 16),
                                // Fullscreen toggle
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Buffering indicator
          if (ctrl.value.isBuffering)
            const CircularProgressIndicator(color: Colors.white54),
        ],
      ),
    );
  }
}
