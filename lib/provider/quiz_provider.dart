import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/models/quiz_model.dart';

final quizProvider = ChangeNotifierProvider((ref) => quizNotifier);

QuizNotifier? _quizNotifier;

QuizNotifier get quizNotifier {
  _quizNotifier ??= QuizNotifier();
  return _quizNotifier!;
}

class QuizNotifier extends ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String _error = '';
  Map<int, String> _userAnswers = {};

  List<QuizQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String get error => _error;
  Map<int, String> get userAnswers => _userAnswers;
  QuizQuestion? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;

  int get totalQuestions => _questions.length;
  int get correctAnswers => _userAnswers.entries
      .where((entry) => entry.value == _questions[entry.key].correctAnswer)
      .length;
  int get incorrectAnswers => _userAnswers.length - correctAnswers;

  void answerQuestion(String answer) {
    if (!_userAnswers.containsKey(_currentQuestionIndex)) {
      _userAnswers[_currentQuestionIndex] = answer;
      notifyListeners();
    }
  }

  bool isCorrectAnswer(int questionIndex) {
    if (!_userAnswers.containsKey(questionIndex)) return false;
    return _userAnswers[questionIndex] == _questions[questionIndex].correctAnswer;
  }

  bool isQuestionAnswered(int questionIndex) {
    return _userAnswers.containsKey(questionIndex);
  }

  Future<void> loadQuizData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final String response = await rootBundle.loadString('assets/quiz_data.json');
      final data = await json.decode(response);
      final questionsList = data['questions'] as List;

      _questions = questionsList.map((q) => QuizQuestion.fromJson(q)).toList();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get isQuizCompleted {
    return _userAnswers.length == _questions.length;
  }

  // Testni qayta boshlash
  void resetQuiz() {
    _currentQuestionIndex = 0;
    _userAnswers.clear();
    notifyListeners();
  }

  // Navigatsiya metodlari
  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }
}