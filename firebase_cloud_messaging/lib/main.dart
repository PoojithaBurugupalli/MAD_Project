import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('Background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MessagingApp());
}

class MessagingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Messaging',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Firebase Messaging Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  String? notificationText = "No notifications received";

  @override
  void initState() {
    super.initState();

    messaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    messaging.requestPermission();

    // Get FCM token and print it
    messaging.getToken().then((token) {
      print("FCM Token: $token");
    });

    // Subscribe to a topic if needed
    messaging.subscribeToTopic("messaging");

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received");
      _showNotificationDialog(message);
    });

    // Handle notifications when the app is opened from a terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message clicked!");
      _showNotificationDialog(message);
    });
  }

  // Show notification dialog
  void _showNotificationDialog(RemoteMessage message) {
    String notificationType = message.data['type'] ?? 'regular';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notificationType == 'important' ? "🔔 Important Notification" : "Notification"),
          content: Text(message.notification?.body ?? "No message body"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(notificationText!),
      ),
    );
  }
}
