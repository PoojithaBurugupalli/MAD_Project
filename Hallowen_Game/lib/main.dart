import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween Spooky Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _player = AudioPlayer();
  bool foundCorrectItem = false;
  double _ghostLeft = 50.0;
  double _ghostTop = 100.0;
  double _pumpkinLeft = 150.0;
  double _pumpkinTop = 300.0;
  bool _musicStarted = false;  // To track if music has started

  @override
  void initState() {
    super.initState();
    _animateGhost();
  }

  // Start background music
  void _startBackgroundMusic() async {
    if (!_musicStarted) {
      _musicStarted = true;
      try {
        await _player.setLoopMode(LoopMode.one);  // Loop background music
        await _player.setAsset('assets/sounds/spooky_music.mp3');
        _player.play();
      } catch (e) {
        print("Error loading background music: $e");
      }
    }
  }

  // Animate the ghost
  void _animateGhost() {
    setState(() {
      _ghostLeft = Random().nextDouble() * 300;
      _ghostTop = Random().nextDouble() * 500;
    });
    Future.delayed(const Duration(seconds: 2), _animateGhost);
  }

  // Handle taps on game items
  void _onItemTapped(bool isTrap) {
    if (!_musicStarted) _startBackgroundMusic();  // Start music on first interaction

    if (isTrap) {
      // Play trap sound and show a spooky reaction (scary message or animation)
      _playSound('assets/sounds/jumpscare.mp3');
      _showSpookyReaction();
    } else {
      setState(() {
        foundCorrectItem = true;
      });
      _playSound('assets/sounds/success_sound.mp3');  // Play success sound
      _showSuccessAnimation();  // Show success animation
    }
  }

  // Play a sound from assets
  void _playSound(String assetPath) async {
    try {
      await _player.setAsset(assetPath);
      _player.play();
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  // Spooky reaction when the wrong item is clicked
  void _showSpookyReaction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        content: const Text(
          'BOO! You hit a trap!',
          style: TextStyle(color: Colors.red, fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();  // Close the spooky dialog after 2 seconds
    });
  }

  // Success animation when the correct item is found
  void _showSuccessAnimation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'You Found It!',
              style: TextStyle(color: Colors.green, fontSize: 30),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image.asset('assets/images/ghost.jpeg', width: 100, height: 100),  // Ghost animation
            const Text(
              'Spooky Success!',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();  // Close the success animation after 2 seconds
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find the Correct Item'),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpeg',  // Your spooky background image
              fit: BoxFit.cover,
            ),
          ),
          // Ghost
          Positioned(
            left: _ghostLeft,
            top: _ghostTop,
            child: GestureDetector(
              onTap: () => _onItemTapped(false),  // The correct item
              child: Image.asset('assets/images/ghost.jpeg', width: 120, height: 120),  // Increased ghost image size
            ),
          ),
          // Pumpkin
          Positioned(
            left: _pumpkinLeft,
            top: _pumpkinTop,
            child: GestureDetector(
              onTap: () => _onItemTapped(false),  // Correct item
              child: Image.asset('assets/images/pumpkin.jpeg', width: 120, height: 120),  // Increased pumpkin image size
            ),
          ),
          // Trap
          Positioned(
            left: 200,
            top: 400,
            child: GestureDetector(
              onTap: () => _onItemTapped(true),  // A trap item
              child: Image.asset('assets/images/trap.jpeg', width: 120, height: 120),  // Increased trap image size
            ),
          ),
          if (foundCorrectItem)
            const Center(
              child: Text(
                'You Found It!',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
        ],
      ),
    );
  }
}