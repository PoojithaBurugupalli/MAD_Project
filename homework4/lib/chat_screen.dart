import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  final String boardName; // Pass the name of the message board
  final TextEditingController messageController = TextEditingController();

  ChatScreen({required this.boardName}); // Constructor to receive boardName

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(boardName), // Display the name of the board
      ),
      body: Column(
        children: [
          // Display messages in real-time
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messageBoards') // Access messageBoards collection
                  .doc(boardName) // Access specific board by its name
                  .collection('messages') // Access messages subcollection
                  .orderBy('datetime', descending: true) // Order messages by time
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // Map the messages into a ListView
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true, // Show newest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['message']),
                      subtitle: Text("By: ${message['username']}"),
                      trailing: Text(message['datetime']),
                    );
                  },
                );
              },
            ),
          ),

          // Message input field and send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      labelText: "Enter your message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (messageController.text.isNotEmpty) {
                      // Send the message to Firestore
                      await FirebaseFirestore.instance
                          .collection('messageBoards')
                          .doc(boardName)
                          .collection('messages')
                          .add({
                        'message': messageController.text.trim(),
                        'datetime': DateTime.now().toIso8601String(),
                        'username': 'Anonymous', // Replace with logged-in user's name
                      });

                      messageController.clear(); // Clear the input field
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
