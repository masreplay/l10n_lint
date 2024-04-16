import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // expect_lint: avoid_string_literals_inside_widget
    return const Text('nasty string literals will not support l10n!');
  }
}
