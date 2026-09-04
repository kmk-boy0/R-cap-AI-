import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String streamUrl;
  final String title;

  const VideoPlayerWidget({
    Key? key,
    required this.streamUrl,
    required this.title,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background placeholder for video stream
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isPlaying ? Icons.live_tv : Icons.tv,
                size: 64,
                color: Colors.white54,
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isPlaying ? "Lecture du flux vidéo..." : "Flux de streaming prêt",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),

          // Play/Pause Overlay Button
          Positioned(
            child: IconButton(
              iconSize: 56,
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: Colors.redAccent,
              ),
              onPressed: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
              },
            ),
          ),

          // Video Controls Bar
          Positioned(
            bottom: 8,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Text(
                  _isPlaying ? "04:15" : "00:00",
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: _isPlaying ? 0.25 : 0.0,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "45:00",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
