import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FadingTextAnimation(),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  const FadingTextAnimation({super.key});

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth fade effect
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth scaling effect
    );
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });

    if (_isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Fading & Scaling Animation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GestureDetector to toggle visibility on tap for text
            GestureDetector(
              onTap: toggleVisibility,
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: const Text(
                  'Click me to dissappear!!!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // GestureDetector to toggle visibility on tap for image
            GestureDetector(
              onTap: toggleVisibility,
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: ScaleTransition(
                  scale: _scaleAnimation, // Scaling effect
                  child: Image.asset(
                    'halloween.jpg', // Path to image in assets
                    width: screenSize.width *
                        0.8, // Set width to 80% of screen width
                    height: screenSize.height *
                        0.4, // Set height to 40% of screen height
                    fit: BoxFit.contain, // Maintain aspect ratio
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40.0), // Space above the button
        child: SizedBox(
          height: 60, // Height of the bottom navigation bar
          child: Center(
            child: FloatingActionButton(
              onPressed: toggleVisibility,
              child: const Icon(Icons.play_arrow),
            ),
          ),
        ),
      ),
    );
  }
}
