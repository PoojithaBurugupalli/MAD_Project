import 'dart:async';
import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import 'summary_screen.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;

  QuizScreen({required this.questions});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  String _feedback = '';
  String _timeMessage = '';
  late QuizQuestion _currentQuestion;
  late Timer _timer;
  int _timeLeft = 30; // 30 seconds per question
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    _currentQuestion = widget.questions[_currentIndex];
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 400), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft -= 1;
          _progress = _timeLeft / 30; // Update progress for the circular timer
        });
      } else {
        _timeUp();
      }
    });
  }

  void _timeUp() {
    _timer.cancel();
    setState(() {
      _answered = true;
      _timeMessage = 'Time’s up!';
      _feedback = 'The correct answer is: ${_currentQuestion.correctAnswer}';
    });
  }

  void _checkAnswer(String answer) {
    _timer.cancel();
    setState(() {
      _answered = true;
      if (answer == _currentQuestion.correctAnswer) {
        _score++;
        _feedback = 'Correct!';
      } else {
        _feedback = 'Incorrect! The correct answer is: ${_currentQuestion.correctAnswer}';
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _currentQuestion = widget.questions[_currentIndex];
        _answered = false;
        _feedback = '';
        _timeMessage = '';
        _timeLeft = 20; // Reset timer
        _progress = 1.0; // Reset progress
        _startTimer();
      });
    } else {
      _showSummary();
    }
  }

  void _showSummary() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SummaryScreen(
          score: _score,
          total: widget.questions.length,
          questions: widget.questions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz (${_currentIndex + 1}/${widget.questions.length})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircularProgressIndicator(
              value: _progress,
              valueColor: AlwaysStoppedAnimation<Color>(_timeLeft > 5 ? Colors.green : Colors.red),
              strokeWidth: 8,
            ),
            SizedBox(height: 20),
            Text(
              'Time Left: $_timeLeft seconds',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            SizedBox(height: 20),
            Text(
              _currentQuestion.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._currentQuestion.options.map((option) {
              return ElevatedButton(
                onPressed: _answered ? null : () => _checkAnswer(option),
                child: Text(option),
              );
            }).toList(),
            if (_answered) ...[
              Text(
                _feedback,
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              if (_timeMessage.isNotEmpty)
                Text(
                  _timeMessage,
                  style: TextStyle(fontSize: 16, color: Colors.orange),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text('Next Question'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
