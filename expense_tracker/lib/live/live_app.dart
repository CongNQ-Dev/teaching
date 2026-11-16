import 'package:expense_tracker/live/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class LiveApp extends StatelessWidget {
  const LiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Expenses(),
    );
  }
}
