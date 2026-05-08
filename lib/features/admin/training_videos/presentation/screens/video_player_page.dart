import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../../core/config/env.dart';
import '../../../../auth/data/services/admin_token_store.dart';
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

  @override
  void initState() {
    super.initState();

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final _tokenStore = const AdminTokenStore();
    try {
      final projecturl = Env.apiProjectBaseUrl;
      final fullUrl = widget.videoUrl.startsWith('http')
          ? widget.videoUrl
          : '$projecturl${widget.videoUrl}';

      print("VIDEO URL = $fullUrl");

      // ✅ await the token properly
      final token = await _tokenStore.getToken();

      print("Token null? ${token == null}");
      print("Token length: ${token?.length}");

      if (token == null || token.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'No auth token found. Please login again.';
        });
        return;
      }

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(fullUrl),
        httpHeaders: {
          'Authorization': 'Bearer $token', // ✅ now has real token value
          'Accept': '*/*',
        },
      );

      await _controller!.initialize();
      await _controller!.play();

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
            ? Text(_error!)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),

            const SizedBox(height: 20),

            IconButton(
              iconSize: 60,
              onPressed: () {
                setState(() {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
              icon: Icon(
                _controller!.value.isPlaying
                    ? Icons.pause_circle
                    : Icons.play_circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}