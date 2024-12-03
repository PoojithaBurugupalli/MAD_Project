class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({required this.question, required this.options, required this.correctAnswer});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final options = List<String>.from(json['incorrect_answers']);
    options.add(json['correct_answer']);
    options.shuffle();
    return QuizQuestion(
      question: json['question'],
      options: options,
      correctAnswer: json['correct_answer'],
    );
  }
}
