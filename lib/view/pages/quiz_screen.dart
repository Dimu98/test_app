import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_app/helpers/assets.dart';
import 'package:test_app/helpers/size.dart';
import 'package:test_app/helpers/theme.dart';
import 'package:test_app/provider/quiz_provider.dart';
import 'package:test_app/view/widgets/test_result.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _timeLeft = 60;
  bool _isTestCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizProvider).loadQuizData();
      _showStartDialog();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _showTimeUpDialog();
        }
      });
    });
  }

  void _showResults() {
    final quizState = ref.read(quizProvider);
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TestResultsDialog(
          totalTests: quizState.questions.length,
          correctAnswers: quizState.correctAnswers,
          incorrectAnswers: quizState.incorrectAnswers,
          timeSpent: Duration(seconds: 60 - _timeLeft),
        );
      },
    );
  }

  Future<void> _showTimeUpDialog() async {
    if (!_isTestCompleted) {
      _isTestCompleted = true;
      _showResults();
    }
  }

  void _checkQuizCompletion() {
    final quizState = ref.read(quizProvider);
    if (quizState.isQuizCompleted && !_isTestCompleted) {
      _isTestCompleted = true;
      _showResults();
    }
  }

  void _restartQuiz() {
    setState(() {
      _timeLeft = 60;
      _isTestCompleted = false;
    });
    ref.read(quizProvider).resetQuiz();
    _startTimer();
  }

  String _formatTime() {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void _scrollToQuestion(int index) {
    if (_scrollController.hasClients) {
      final double itemWidth = 45.0;
      final double screenWidth = MediaQuery.of(context).size.width;
      final double scrollOffset =
          (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      _scrollController.animateTo(
        scrollOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _showStartDialog() async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: theme.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.o),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1.sw(context) * 0.8,
            maxHeight: 1.sh(context) * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Testga tayyormisiz?',
                    textAlign: TextAlign.center,
                    style: theme.textStyle.copyWith(
                      fontSize: 24.o,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  20.o.gapY,
                  SizedBox(
                    width: double.infinity,
                    height: 50.o,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _startTimer();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.o),
                        ),
                      ),
                      child: Text(
                        'Tayyorman',
                        style: theme.textStyle.copyWith(
                          fontSize: 16.o,
                          color: theme.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    ThemeData tema = Theme.of(context);

    ref.listen<int>(
      quizProvider.select((provider) => provider.currentQuestionIndex),
      (previous, next) {
        _scrollToQuestion(next);
      },
    );

    return Scaffold(
      backgroundColor: tema.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: 1.sw(context),
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.o),
                  color: theme.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(Assets.icon.logoout),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(Assets.icon.og),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(Assets.icon.dark),
                    ),
                    Container(
                      width: 78,
                      height: 28,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34.o),
                        color: const Color(0xffF1F3F7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset(Assets.icon.time),
                          Text(
                            _formatTime(),
                            style: theme.textStyle.copyWith(
                              fontSize: 11.o,
                              color: _timeLeft <= 10 ? Colors.red : null,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              20.o.gapY,
              if (quizState.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (quizState.error.isNotEmpty)
                Center(child: Text(quizState.error))
              else ...[
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: quizState.questions.length,
                    itemBuilder: (context, index) {
                      final isAnswered = quizState.isQuestionAnswered(index);
                      final isCorrect =
                          isAnswered && quizState.isCorrectAnswer(index);

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_drop_down_sharp,
                              color: quizState.currentQuestionIndex == index
                                  ? theme.blue
                                  : Colors.transparent,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => quizState.goToQuestion(index),
                            child: Container(
                              alignment: Alignment.center,
                              width: 35.o,
                              height: 35.o,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.o),
                                color: isAnswered
                                    ? (isCorrect ? Colors.green : Colors.red)
                                    : theme.green,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: theme.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                24.o.gapY,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 1.sw(context),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.o),
                            border: Border.all(width: 1, color: theme.blue),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Savol:',
                                style: theme.textStyle.copyWith(
                                  fontSize: 20.o,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              8.o.gapY,
                              Text(
                                quizState.currentQuestion?.question ?? '',
                                maxLines: 5,
                                style: theme.textStyle,
                              ),
                            ],
                          ),
                        ),
                        20.o.gapY,
                        Text(
                          'Javoblar',
                          style: theme.textStyle
                              .copyWith(color: const Color(0xff8192A5)),
                        ),
                        12.o.gapY,
                        ...List.generate(
                          quizState.currentQuestion?.options.length ?? 0,
                          (index) => _buildAnswerOption(
                            String.fromCharCode(65 + index),
                            quizState.currentQuestion?.options[index] ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => quizState.previousQuestion(),
                      icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    ),
                    Text(
                      '${quizState.currentQuestionIndex + 1}/${quizState.questions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    IconButton(
                      onPressed: () => quizState.nextQuestion(),
                      icon: const Icon(
                        Icons.arrow_forward_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerOption(String letter, String text) {
    final quizState = ref.watch(quizProvider);
    final isAnswered =
        quizState.isQuestionAnswered(quizState.currentQuestionIndex);
    final isSelected = isAnswered &&
        quizState.userAnswers[quizState.currentQuestionIndex] == text;
    final isCorrectAnswer = text == quizState.currentQuestion?.correctAnswer;

    Color getBackgroundColor() {
      if (!isAnswered) return theme.white;
      if (isCorrectAnswer) return Colors.green.shade100;
      if (isSelected) return Colors.red.shade100;
      return theme.white;
    }

    Color getBorderColor() {
      if (!isAnswered) return Colors.transparent;
      if (isCorrectAnswer) return Colors.green;
      if (isSelected) return Colors.red;
      return Colors.transparent;
    }

    return GestureDetector(
      onTap: () {
        if (!isAnswered && !_isTestCompleted) {
          quizState.answerQuestion(text);
          _checkQuizCompletion();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: BorderRadius.circular(8.o),
          border: Border.all(
            color: getBorderColor(),
            width: isAnswered ? 2 : 0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                letter,
                style: theme.textStyle.copyWith(
                  color: theme.blue,
                  fontSize: 20.o,
                  fontWeight: FontWeight.w500,
                ),
              ),
              12.o.gapX,
              Expanded(
                child: Text(
                  text,
                  maxLines: 3,
                  style: theme.textStyle.copyWith(
                    color: isAnswered && isCorrectAnswer ? Colors.green : null,
                  ),
                ),
              ),
              if (isAnswered && (isSelected || isCorrectAnswer))
                Icon(
                  isCorrectAnswer ? Icons.check_circle : Icons.cancel,
                  color: isCorrectAnswer ? Colors.green : Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }
}