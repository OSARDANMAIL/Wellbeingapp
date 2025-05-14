import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CalmSoundsPage extends StatefulWidget {
  @override
  _CalmSoundsPageState createState() => _CalmSoundsPageState();
}

class _CalmSoundsPageState extends State<CalmSoundsPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? currentSound;

  final List<Map<String, String>> sounds = [
    {
      'title': 'Rain',
      'file': 'assets/sounds/rainy-day-in-town-with-birds-singing-194011.mp3'
    },
    {'title': 'Forest', 'file': 'assets/sounds/forest.mp3'},
    {'title': 'Ocean Waves', 'file': 'assets/sounds/ocean.mp3'},
    {'title': 'Soft Piano', 'file': 'assets/sounds/piano.mp3'},
    {'title': 'Gentle Wind', 'file': 'assets/sounds/wind.mp3'},
  ];

  void playSound(String filePath) async {
    await _audioPlayer.stop();

    // ✅ This is the key line to add:
    await _audioPlayer.play(AssetSource(filePath.replaceFirst('assets/', '')));

    setState(() {
      currentSound = filePath;
    });
  }

  void stopSound() async {
    await _audioPlayer.stop();
    setState(() {
      currentSound = null;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calm Sounds")),
      body: ListView.builder(
        itemCount: sounds.length,
        itemBuilder: (context, index) {
          final sound = sounds[index];
          final isPlaying = currentSound == sound['file'];

          return Card(
            margin: const EdgeInsets.all(12),
            color: Colors.purple.shade50,
            child: ListTile(
              title: Text(
                sound['title']!,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                onPressed: () {
                  isPlaying ? stopSound() : playSound(sound['file']!);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
