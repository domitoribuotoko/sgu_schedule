import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';

void trace([String message = '', int frame = 1]) {
  String trace = Trace.current().frames[frame].member.toString();
  if (message.isNotEmpty) {
    message = ': ${message.cyan}';
  }
  debugPrint('${trace.yellow}$message');
}

class ConsoleColor {
  ConsoleColor._();

  static const String reset = '\x1B[0m';
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';

  // Яркие цвета
  static const String brightRed = '\x1B[91m';
  static const String brightGreen = '\x1B[92m';
  static const String brightYellow = '\x1B[93m';
  static const String brightBlue = '\x1B[94m';
  static const String todo = '\x1B[38;2;153;204;51m';

  // Фоновые цвета
  static const String bgRed = '\x1B[41m';
  static const String bgGreen = '\x1B[42m';
  static const String bgYellow = '\x1B[43m';
  static const String bgBlue = '\x1B[44m';
}

extension ColoredString on String {
  String colored(String color) => '$color$this${ConsoleColor.reset}';

  // Готовые методы для часто используемых цветов
  String get magenta => colored(ConsoleColor.magenta);

  String get red => colored(ConsoleColor.red);

  String get brightRed => colored(ConsoleColor.brightRed);

  String get brightBlue => colored(ConsoleColor.brightBlue);

  String get brightGreen => colored(ConsoleColor.brightGreen);

  String get todo => colored(ConsoleColor.todo);

  String get green => colored(ConsoleColor.green);

  String get blue => colored(ConsoleColor.blue);

  String get yellow => colored(ConsoleColor.yellow);

  String get brightYellow => colored(ConsoleColor.brightYellow);

  String get cyan => colored(ConsoleColor.cyan);
}

extension AppColorsEx on Color {
  Color aChannel(double alpha) {
    final double clamped = alpha < 0 ? 0 : (alpha > 1 ? 1 : alpha);
    return withAlpha((255 * clamped).toInt());
  }

  bool get isEmpty => this == Colors.transparent;
}
