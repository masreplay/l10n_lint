import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // no expect_lint: avoid_string_literals_inside_widget
    return const Text('hard code string literals will not support l10n!');
  }
}
