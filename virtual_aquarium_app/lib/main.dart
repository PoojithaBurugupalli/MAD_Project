import 'package:flutter/material.dart';
import 'dart:math';
import 'package:virtual_aquarium_app/data_helper.dart';

void main() {
  runApp(VirtualAquariumApp());
}

class VirtualAquariumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Aquarium',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AquariumScreen(),
    );
  }
}

class AquariumScreen extends StatefulWidget {
  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen> with TickerProviderStateMixin {
  List<Fish> fishList = [];
  String selectedColor = 'Blue';
  double selectedSpeed = 1.0;
  bool collisionEnabled = true;
  late AnimationController _controller;
  final DataHelper _dataHelper = DataHelper();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    Map<String, dynamic>? settings = await _dataHelper.loadSettings();
    if (settings != null) {
      setState(() {
        fishList = List.generate(
          settings['fishCount'],
          (index) => Fish(
            color: settings['fishColor'],
            speed: settings['fishSpeed'].toDouble(),
          ),
        );
        selectedSpeed = settings['fishSpeed'].toDouble();
        selectedColor = settings['fishColor'];
      });
    }
  }

  void _addFish() {
    if (fishList.length < 10) {
      setState(() {
        fishList.add(Fish(color: selectedColor, speed: selectedSpeed));
      });
    }
  }

  void _removeFish() {
    if (fishList.isNotEmpty) {
      setState(() {
        fishList.removeLast();
      });
    }
  }

  Future<void> _saveSettings() async {
    await _dataHelper.saveSettings(
      fishList.length,
      selectedColor,
      selectedSpeed,
    );
  }

  void _toggleCollision() {
    setState(() {
      collisionEnabled = !collisionEnabled;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> get colorDropdownItems {
    return [
      DropdownMenuItem(value: 'Blue', child: Text('Blue')),
      DropdownMenuItem(value: 'Red', child: Text('Red')),
      DropdownMenuItem(value: 'Green', child: Text('Green')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Aquarium'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: 300,
            color: Colors.lightBlueAccent,
            child: Stack(
              children: fishList
                  .map((fish) => AnimatedFish(fish: fish, fishList: fishList, collisionEnabled: collisionEnabled))
                  .toList(),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Adjust Fish Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: selectedSpeed,
            min: 0.5,
            max: 5.0,
            divisions: 10,
            label: 'Speed: ${selectedSpeed.toStringAsFixed(1)}',
            onChanged: (double value) {
              setState(() {
                selectedSpeed = value;
              });
            },
          ),
          DropdownButton<String>(
            value: selectedColor,
            items: colorDropdownItems,
            onChanged: (String? color) {
              setState(() {
                if (color != null) {
                  selectedColor = color;
                }
              });
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _addFish,
                child: Text('Add Fish'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _removeFish,
                child: Text('Remove Fish'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _saveSettings,
                child: Text('Save Settings'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enable Collision Effects'),
              Switch(
                value: collisionEnabled,
                onChanged: (value) {
                  _toggleCollision();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Fish {
  String color;
  double speed;
  Offset position = Offset(0, 0); // Track fish position

  Fish({required this.color, required this.speed});
}

class AnimatedFish extends StatefulWidget {
  final Fish fish;
  final List<Fish> fishList;
  final bool collisionEnabled;

  const AnimatedFish({Key? key, required this.fish, required this.fishList, required this.collisionEnabled})
      : super(key: key);

  @override
  _AnimatedFishState createState() => _AnimatedFishState();
}

class _AnimatedFishState extends State<AnimatedFish> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Random random = Random();
  bool isCollided = false;

  double randomDouble() => random.nextDouble();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (6 / widget.fish.speed).round()),
    )..repeat(reverse: true);

    _animation = Tween(
      begin: Offset(randomDouble(), randomDouble()),
      end: Offset(randomDouble(), randomDouble()),
    ).animate(_controller);
  }

  void _checkForCollision(Fish fish1, Fish fish2) {
    if ((fish1.position.dx - fish2.position.dx).abs() < 20 &&
        (fish1.position.dy - fish2.position.dy).abs() < 20) {
      fish1.speed = random.nextDouble() * 3 + 1; // Random speed change
      fish2.speed = random.nextDouble() * 3 + 1; // Random speed change

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        setState(() {
          fish1.color = Random().nextBool() ? 'Blue' : 'Red'; // Random color change
          fish2.color = Random().nextBool() ? 'Green' : 'Blue'; // Random color change
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/fish_${widget.fish.color.toLowerCase()}.png';

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (widget.collisionEnabled) {
          // Detect collision with other fish
          for (Fish otherFish in widget.fishList) {
            if (otherFish != widget.fish) {
              _checkForCollision(widget.fish, otherFish);
            }
          }
        }

        widget.fish.position = _animation.value;

        return Positioned(
          left: _animation.value.dx * 280,
          top: _animation.value.dy * 280,
          child: Transform.scale(
            scale: isCollided ? 1.2 : 1.0, // Slight scaling effect when added
            child: Image.asset(
              imagePath,
              width: 30,
              height: 30,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
