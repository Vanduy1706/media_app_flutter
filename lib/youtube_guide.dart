import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ApiYoutube extends StatefulWidget {
  const ApiYoutube({super.key});

  @override
  State<ApiYoutube> createState() => _ApiYoutubeState();
}

class _ApiYoutubeState extends State<ApiYoutube> {
  String API_KEY = 'AIzaSyCx2M_3K2oXI39FLLl4LgcCmnpzjUFnX0U';
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'x0_zAkTy94I',
      flags: YoutubePlayerFlags(autoPlay: true, mute: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hướng dẫn sử dụng'),
      ),
      body: Column(
        children: [
          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                _controller.play();
              },
            ),
          ),
          // Nội dung văn bản
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Hướng dẫn các bạn cách sử dụng ứng dụng mạng xã hội này !',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}