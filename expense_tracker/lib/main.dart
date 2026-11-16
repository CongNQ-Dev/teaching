import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/live/live_app.dart';
import 'package:expense_tracker/solution/solution_app.dart';

/// Chế độ khởi động, chọn bằng:
///   flutter run --dart-define=MODE=solution
///   flutter run --dart-define=MODE=live   (mặc định)
const _startMode = String.fromEnvironment('MODE', defaultValue: 'live');

void main() {
  runApp(const TeachingRoot());
}

enum AppMode { live, solution }

/// Root dùng để dạy học: chứa cả code đang gõ live (lib/live/)
/// và code đáp án (lib/solution/), chuyển qua lại ngay khi app đang chạy
/// bằng nút nhỏ ở góc dưới bên trái (chỉ hiện ở debug mode).
class TeachingRoot extends StatefulWidget {
  const TeachingRoot({super.key});

  @override
  State<TeachingRoot> createState() => _TeachingRootState();
}

class _TeachingRootState extends State<TeachingRoot> {
  AppMode _mode = _startMode == 'solution' ? AppMode.solution : AppMode.live;

  void _toggleMode() {
    setState(() {
      _mode = _mode == AppMode.live ? AppMode.solution : AppMode.live;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = _mode == AppMode.solution
        ? const SolutionApp(key: ValueKey('solution'))
        : const LiveApp(key: ValueKey('live'));

    if (!kDebugMode) return app;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          app,
          Positioned(
            bottom: 0,
            left: 0,
            child: SafeArea(
              child: _ModeSwitchButton(mode: _mode, onTap: _toggleMode),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeSwitchButton extends StatelessWidget {
  const _ModeSwitchButton({required this.mode, required this.onTap});

  final AppMode mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSolution = mode == AppMode.solution;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSolution ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          isSolution ? 'SOLUTION ⇄' : 'LIVE ⇄',
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
