import 'package:flutter/material.dart';
import 'db_helper.dart';

class CardScreen extends StatefulWidget {
  final int folderId;
  final String folderName;

  CardScreen({required this.folderId, required this.folderName});

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  List<Map<String, dynamic>> _cards = [];
  DatabaseHelper dbHelper = DatabaseHelper();
  static const maxCards = 6;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    _cards = await dbHelper.getCardsForFolder(widget.folderId);
    setState(() {});
  }

  void _addCard(String cardName, String suit, String imageUrl) async {
    if (_cards.length >= maxCards) {
      _showLimitDialog();
      return;
    }
    await dbHelper.insertCard({
      'name': cardName,
      'suit': suit,
      'image_url': imageUrl,
      'folder_id': widget.folderId,
    });
    _loadCards();
  }

  void _deleteCard(int cardId) async {
    await dbHelper.deleteCard(cardId);
    _loadCards();
  }

  void _showLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Card Limit Reached'),
        content: Text('This folder can only hold 6 cards.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.folderName} Cards'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return Card(
            child: Stack(
              children: [
                Image.asset(card['image_url']), // Load from assets
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteCard(card['id']),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _addCard('Ace', widget.folderName, _getImagePathForCard(widget.folderName, 'Ace'));
        },
      ),
    );
  }

  String _getImagePathForCard(String suit, String cardName) {
    return 'assets/images/${suit.toLowerCase()}_${cardName.toLowerCase()}.png';
  }
}
