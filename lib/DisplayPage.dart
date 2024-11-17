import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // مكتبة مشغل الفيديو

class DisplayPage extends StatelessWidget {
  final String imagePath; // مسار الصورة الجديدة
  final String title; // العنوان

  const DisplayPage({
    super.key,
    required this.imagePath,
    required this.title,
  });

  // دالة لعرض معلومات عن النظام
  void _showSystemInfo(BuildContext context, String systemTitle) {
    String info = '';

    switch (systemTitle) {
      case 'Integumentary System':
        info =
            'The integumentary system includes the skin, hair, nails, and glands. It serves as the body’s outer protective layer and plays several critical roles in maintaining overall health.';
        break;
      case 'Skeletal System':
        info =
            'The skeletal system includes all of the bones and joints in the body. Each bone is a complex living organ that is made up of many cells, protein fibers, and minerals. The skeletal system in an adult body is made up of 206 individual bones.';
        break;
      case 'Muscular System':
        info =
            'The muscular system is responsible for the movement of the human body. Attached to the bones of the skeletal system are about 700 named muscles that make up roughly half of a persons body weight.';
        break;
      case 'Cardiovascular System':
        info =
            'The cardiovascular system includes the heart and blood vessels, responsible for circulating blood throughout the body.';
        break;
      case 'Digestive System':
        info =
            'The digestive system breaks down food into nutrients for absorption and eliminates waste from the body.';
        break;
      case 'Nervous System':
        info =
            'The nervous system controls the body’s movements and activities by transmitting electrical signals between the brain, spinal cord, and nerves.';
        break;
      case 'Urinary System':
        info =
            'The urinary system removes waste products from the blood and maintains the balance of fluids and electrolytes.';
        break;
      case 'Female Reproductive System':
        info =
            'The female reproductive system produces eggs and supports the development of a fetus during pregnancy.';
        break;
      case 'Male Reproductive System':
        info =
            'The male reproductive system produces sperm and facilitates the fertilization of the female egg.';
        break;
      default:
        info = 'No information available.';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(' $systemTitle'),
          content: SingleChildScrollView(
            child: Text(info),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showVideo(context, systemTitle);
              },
              child: const Text('Watch Video'),
            ),
          ],
        );
      },
    );
  }

  void _showVideo(BuildContext context, String systemTitle) {
    String videoPath;

    switch (systemTitle) {
      case 'Skeletal System':
        videoPath = 'images/skillvid.mp4';
        break;
      case 'Muscular System':
        videoPath = 'images/mucvvid.mp4';
        break;
      case 'Cardiovascular System':
        videoPath = 'images/dowvid.mp4';
        break;
      case 'Digestive System':
        videoPath = 'images/digesvid.mp4';
        break;
      case 'Nervous System':
        videoPath = 'images/nervvid.mp4';
        break;
      default:
        videoPath = '';
    }

    if (videoPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video not available for this system.')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPage(videoPath: videoPath),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 50, 84),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showSystemInfo(context, title);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(
                imagePath,
                width: 500,
                height: 500,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final String videoPath;

  const VideoPage({super.key, required this.videoPath});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset(widget.videoPath);
    await _controller.initialize();
    setState(() {});
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch Video'),
      ),
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
