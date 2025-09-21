import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class ConsumerReelsScreen extends StatefulWidget {
  @override
  _ConsumerReelsScreenState createState() => _ConsumerReelsScreenState();
}

class _ConsumerReelsScreenState extends State<ConsumerReelsScreen> {
  void _playHardcodedReel() async {
    try {
      // Convert your gs:// URL to download URL
      final ref = FirebaseStorage.instance.refFromURL(
        'gs://artisan-app-media/artisans/K1QV3JljnceYOcj2fFE2ZST01473/products/6J3NHVmEiZc0xxozKUeW/final_reel.mp4',
      );
      final downloadUrl = await ref.getDownloadURL();

      // Show reel player
      showDialog(
        context: context,
        builder: (context) => ReelPlayerDialog(videoUrl: downloadUrl),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading reel: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.purple.shade300, Colors.blue.shade300],
                ),
              ),
              child: InkWell(
                onTap: _playHardcodedReel,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_filled,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Paper mache balls',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Tap to play reel',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reel Player Dialog (same as before)
class ReelPlayerDialog extends StatefulWidget {
  final String videoUrl;

  const ReelPlayerDialog({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<ReelPlayerDialog> createState() => _ReelPlayerDialogState();
}

class _ReelPlayerDialogState extends State<ReelPlayerDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
    setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Stack(
          children: [
            if (_isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            else
              Center(child: CircularProgressIndicator()),

            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
