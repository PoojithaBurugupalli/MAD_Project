import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'quiz_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _numQuestions = 5;
  String _category = '9';
  String _difficulty = 'easy';
  String _type = 'multiple';
  List<dynamic> _categories = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final categories = await apiService.fetchCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<int>(
              value: _numQuestions,
              items: [5, 10, 15]
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e Questions')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _numQuestions = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: _category,
              items: _categories
                  .map((cat) => DropdownMenuItem(
                      value: cat['id'].toString(),
                      child: Text(cat['name'])))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: _difficulty,
              items: ['easy', 'medium', 'hard']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.capitalize())))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _difficulty = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: _type,
              items: ['multiple', 'boolean']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.capitalize())))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final questions = await apiService.fetchQuestions(
                  numberOfQuestions: _numQuestions,
                  category: _category,
                  difficulty: _difficulty,
                  type: _type,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(questions: questions),
                  ),
                );
              },
              child: Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
