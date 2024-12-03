import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_model.dart';

class ApiService {
  final String baseUrl = 'https://opentdb.com';

  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api_category.php'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['trivia_categories'];
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<QuizQuestion>> fetchQuestions({
    required int numberOfQuestions,
    required String category,
    required String difficulty,
    required String type,
  }) async {
    final url = Uri.parse('$baseUrl/api.php?amount=$numberOfQuestions&category=$category&difficulty=$difficulty&type=$type');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['results'] as List;
      return data.map((json) => QuizQuestion.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
