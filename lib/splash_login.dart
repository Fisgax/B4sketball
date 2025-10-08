import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'login_screen.dart'; // importa o ecrã de login real

class SplashLogin extends StatefulWidget {
  const SplashLogin({super.key});

  @override
  State<SplashLogin> createState() => _SplashLoginState();
}

class _SplashLoginState extends State<SplashLogin> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/videos/cadavaros_7287988521388854534-no-watermark.mp4',
    )
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });

    _controller.setLooping(false);

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
