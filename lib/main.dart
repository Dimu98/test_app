import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/provider/theme_provider.dart';
import 'package:test_app/helpers/size.dart';
import 'package:test_app/helpers/theme.dart';
import 'package:test_app/view/pages/quiz_screen.dart';

void main(List<String> args) {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer(
      builder: (context, ref, child) {
        final notifier = ref.watch(themeProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.light,
          darkTheme: theme.dark,
          themeMode: notifier.themeMode,
          builder: (context, child) {
            height = 1.sh(context) / 812;
            width = 1.sw(context) / 375;
            arifmetik = (height + width) / 2;
            return MediaQuery(data: MediaQuery.of(context), child: child!);
          },
          home: QuizScreen(),
        );
      },
    ),
    );
  }
}