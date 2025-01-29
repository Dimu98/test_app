import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/helpers/navigators.dart';
import 'package:test_app/helpers/size.dart';
import 'package:test_app/helpers/theme.dart';
import 'package:test_app/provider/quiz_provider.dart';
import 'package:test_app/view/pages/quiz_screen.dart';

class TestResultsDialog extends ConsumerWidget {
  final int totalTests;
  final int correctAnswers;
  final int incorrectAnswers;
  final Duration timeSpent;

  const TestResultsDialog({
    Key? key,
    required this.totalTests,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.timeSpent,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData tema = Theme.of(context);
    final percentage = (correctAnswers / totalTests * 100).round();
    
    // Progress rangini aniqlash
    Color getProgressColor() {
      if (percentage >= 90) return theme.green;
      if (percentage >= 70) return theme.yellow;
      return theme.red;
    }

    // Ball haqidagi xabarni aniqlash
    String getScoreMessage() {
      if (percentage >= 90) return 'Sizga 1 ball taqdim etildi!';
      return 'Afsuski sizga ball taqdim etilmadi';
    }

    return Dialog(
      backgroundColor: tema.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 128.o,
                  height: 128.o,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Color(0xffDCE1EB),
                    valueColor: AlwaysStoppedAnimation<Color>(getProgressColor()),
                    strokeWidth: 8,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: theme.textStyle.copyWith(
                    fontSize: 24.o,
                    fontWeight: FontWeight.w600,
                    color: getProgressColor(),
                  ),
                ),
              ],
            ),
            20.o.gapY,
            Text(
              'Yakunlandi',
              style: theme.textStyle.copyWith(
                fontSize: 24.o,
                fontWeight: FontWeight.w500,
              ),
            ),
            10.o.gapY,
            Text(
              getScoreMessage(),
              style: theme.textStyle.copyWith(
                fontSize: 15.o,
                color: percentage >= 90 ? theme.green : Colors.black,
              ),
            ),
            5.o.gapY,
            Text(
              'Ja\'mi to\'plangan ballaringiz soni: ${correctAnswers * 5} ta',
              style: theme.textStyle
                  .copyWith(fontSize: 13.o, color: Color(0xff8192A5)),
            ),
            20.o.gapY,
            Text(
              'Umumiy testlar soni: $totalTests',
              style: theme.textStyle
                  .copyWith(fontSize: 13.o, color: Color(0xff575757)),
            ),
            20.o.gapY,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResultBox(correctAnswers.toString(), 'To\'g\'ri javob',
                    Color(0xffE1FFED), theme.green),
                _buildResultBox(
                  incorrectAnswers.toString(),
                  'Noto\'g\'ri javob',
                  Color(0xffFFE6E6),
                  theme.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, color: Colors.orange),
                5.o.gapY,
                Text(
                  ' ${_formatDuration(timeSpent)} / ',
                  style: theme.textStyle.copyWith(
                    color: theme.yellow,
                    fontSize: 15.o,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "1:00",
                  style: theme.textStyle.copyWith(
                    color: theme.yellow,
                    fontSize: 15.o,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(quizProvider).resetQuiz();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.blue,
                minimumSize: Size(1.sw(context), 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restart_alt,
                    color: theme.white,
                    size: 25,
                  ),
                  12.o.gapX,
                  Text(
                    'Qayta urinish',
                    style: theme.textStyle.copyWith(
                        fontSize: 15.o,
                        fontWeight: FontWeight.w400,
                        color: theme.white),
                  ),
                ],
              ),
            ),
            10.o.gapY,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.grey[300],
                minimumSize: Size(1.sw(context), 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                pop(context);
              },
              child: Text(
                'Chiqish',
                style: theme.textStyle.copyWith(
                  color: Color(0xff8192A5),
                  fontSize: 15.o,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultBox(
    String number,
    String label,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      width: 120.o,
      height: 105,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: theme.textStyle.copyWith(
                fontSize: 24.o, fontWeight: FontWeight.w500, color: textColor),
          ),
          5.o.gapY,
          Text(
            label,
            style: theme.textStyle.copyWith(fontSize: 13.o, color: textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}