// ignore_for_file: avoid_annotating_with_dynamic

import "dart:developer" as developer;
import "package:flutter/foundation.dart";

enum LogLevel { debug, info, warning, error, success }

class AppLogger {
  static bool _enabled = true;
  static bool _showTimestamp = true;
  static bool _showEmoji = true;
  static LogLevel _minLevel = LogLevel.debug;
  static String _appName = "Dogbale";

  static void configure({
    bool? enabled,
    bool? showTimestamp,
    bool? showEmoji,
    LogLevel? minLevel,
    String? appName,
  }) {
    if (enabled != null) _enabled = enabled;
    if (showTimestamp != null) _showTimestamp = showTimestamp;
    if (showEmoji != null) _showEmoji = showEmoji;
    if (minLevel != null) _minLevel = minLevel;
    if (appName != null) _appName = appName;
  }

  static void d(dynamic message, {String? tag}) {
    _log(message, LogLevel.debug, tag);
  }

  static void i(dynamic message, {String? tag}) {
    _log(message, LogLevel.info, tag);
  }

  static void w(dynamic message, {String? tag}) {
    _log(message, LogLevel.warning, tag);
  }

  static void e(
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(message, LogLevel.error, tag, error: error, stackTrace: stackTrace);
  }

  static void s(dynamic message, {String? tag}) {
    _log(message, LogLevel.success, tag);
  }

  static void json(Map<String, dynamic> data, {String? tag}) {
    if (!_shouldLog(LogLevel.debug)) return;

    final buffer = StringBuffer()
      ..writeln('📋 JSON Data ${tag != null ? '[$tag]' : ''}:');
    data.forEach((key, value) {
      buffer.writeln("  $key: $value");
    });

    _printLog(buffer.toString(), LogLevel.debug);
  }

  static void list(List<dynamic> items, {String? tag, String? title}) {
    if (!_shouldLog(LogLevel.debug)) return;

    final buffer = StringBuffer()
      ..writeln(
        '📃 ${title ?? 'List'} ${tag != null ? '[$tag]' : ''} '
        "(${items.length} items):",
      );
    for (var i = 0; i < items.length; i++) {
      buffer.writeln("  [$i] ${items[i]}");
    }

    _printLog(buffer.toString(), LogLevel.debug);
  }

  static void method(
    String methodName, {
    Map<String, dynamic>? params,
    String? tag,
  }) {
    if (!_shouldLog(LogLevel.debug)) return;

    final buffer = StringBuffer()..write("🔧 Method: $methodName");
    if (tag != null) buffer.write(" [$tag]");

    if (params != null && params.isNotEmpty) {
      buffer.write("\n  Params:");
      params.forEach((key, value) {
        buffer.write("\n    $key: $value");
      });
    }

    _printLog(buffer.toString(), LogLevel.debug);
  }

  static void route(String routeName, {Map<String, dynamic>? arguments}) {
    if (!_shouldLog(LogLevel.info)) return;

    final buffer = StringBuffer()..write("🧭 Navigation → $routeName");

    if (arguments != null && arguments.isNotEmpty) {
      buffer.write("\n  Arguments:");
      arguments.forEach((key, value) {
        buffer.write("\n    $key: $value");
      });
    }

    _printLog(buffer.toString(), LogLevel.info);
  }

  static void apiRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!_shouldLog(LogLevel.info)) return;

    final buffer = StringBuffer()
      ..writeln("🌐 API Request:")
      ..writeln("  Method: $method")
      ..writeln("  URL: $url");

    if (headers != null && headers.isNotEmpty) {
      buffer.writeln("  Headers:");
      headers.forEach((key, value) {
        buffer.writeln("    $key: $value");
      });
    }

    if (body != null) {
      buffer.writeln("  Body: $body");
    }

    _printLog(buffer.toString(), LogLevel.info);
  }

  static void apiResponse({
    required int statusCode,
    required String url,
    dynamic body,
    Duration? duration,
  }) {
    final level = statusCode >= 200 && statusCode < 300
        ? LogLevel.success
        : LogLevel.error;

    if (!_shouldLog(level)) return;

    final buffer = StringBuffer()
      ..writeln("${_getEmoji(level)} API Response:")
      ..writeln("  URL: $url")
      ..writeln("  Status: $statusCode");

    if (duration != null) {
      buffer.writeln("  Duration: ${duration.inMilliseconds}ms");
    }

    if (body != null) {
      final bodyStr = body.toString();
      if (bodyStr.length > 500) {
        buffer.writeln("  Body: ${bodyStr.substring(0, 500)}... (truncated)");
      } else {
        buffer.writeln("  Body: $bodyStr");
      }
    }

    _printLog(buffer.toString(), level);
  }

  static void section(String title, void Function() content) {
    if (!_enabled) return;

    _printLog("=" * 60, LogLevel.info);
    _printLog("  $title", LogLevel.info);
    _printLog("=" * 60, LogLevel.info);
    content();
    _printLog('${'=' * 60}\n', LogLevel.info);
  }

  static void performance(String operation, Duration duration) {
    if (!_shouldLog(LogLevel.info)) return;

    final emoji = duration.inMilliseconds < 100
        ? "⚡"
        : duration.inMilliseconds < 500
        ? "⏱️"
        : "🐌";

    _printLog(
      "$emoji Performance: $operation took ${duration.inMilliseconds}ms",
      LogLevel.info,
    );
  }

  static Stopwatch startTimer(String label) {
    final stopwatch = Stopwatch()..start();
    d("⏱️ Timer started: $label");
    return stopwatch;
  }

  static void stopTimer(String label, Stopwatch stopwatch) {
    stopwatch.stop();
    performance(label, stopwatch.elapsed);
  }

  static void table(List<Map<String, dynamic>> data, {String? title}) {
    if (!_shouldLog(LogLevel.debug)) return;

    if (data.isEmpty) {
      _printLog('📊 ${title ?? 'Table'}: Empty', LogLevel.debug);
      return;
    }

    final buffer = StringBuffer()
    ..writeln('📊 ${title ?? 'Table'}:')
    ..writeln("─" * 60);

    for (var i = 0; i < data.length; i++) {
      buffer.writeln("Row $i:");
      data[i].forEach((key, value) {
        buffer.writeln("  $key: $value");
      });
      if (i < data.length - 1) buffer.writeln("─" * 60);
    }

    _printLog(buffer.toString(), LogLevel.debug);
  }

  static void _log(
    dynamic message,
    LogLevel level,
    String? tag, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!_shouldLog(level)) return;

    final buffer = StringBuffer();

    if (_showEmoji) {
      buffer.write("${_getEmoji(level)} ");
    }
    buffer.write("[${_getLevelName(level)}]");

    if (tag != null) {
      buffer.write(" [$tag]");
    }

    if (_showTimestamp) {
      buffer.write(" ${_getTimestamp()}");
    }

    buffer.write(": $message");

    if (error != null) {
      buffer.write("\n  Error: $error");
    }

    if (stackTrace != null) {
      buffer.write("\n  StackTrace:\n${_formatStackTrace(stackTrace)}");
    }

    _printLog(buffer.toString(), level);
  }

  static bool _shouldLog(LogLevel level) {
    if (!_enabled) return false;
    return level.index >= _minLevel.index;
  }

  static void _printLog(String message, LogLevel level) {
    if (kDebugMode) {
      // debugPrint évite que les longs messages soient tronqués.
      debugPrint(message);

      // Et on les envoie aussi à DevTools.
      developer.log(
        message,
        name: _appName,
        level: _getDeveloperLogLevel(level),
      );
    }
  }

  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return "🔍";
      case LogLevel.info:
        return "ℹ️";
      case LogLevel.warning:
        return "⚠️";
      case LogLevel.error:
        return "❌";
      case LogLevel.success:
        return "✅";
    }
  }

  static String _getLevelName(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return "DEBUG";
      case LogLevel.info:
        return "INFO";
      case LogLevel.warning:
        return "WARN";
      case LogLevel.error:
        return "ERROR";
      case LogLevel.success:
        return "SUCCESS";
    }
  }

  static int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.success:
        return 800;
    }
  }

  static String _getTimestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';
  }

  static String _formatStackTrace(StackTrace stackTrace) {
    final lines = stackTrace.toString().split("\n");
    final formatted = lines.take(5).map((line) => "    $line").join("\n");
    return formatted;
  }
}

class Log {
  static void d(dynamic message, {String? tag}) =>
      AppLogger.d(message, tag: tag);
  static void i(dynamic message, {String? tag}) =>
      AppLogger.i(message, tag: tag);
  static void w(dynamic message, {String? tag}) =>
      AppLogger.w(message, tag: tag);
  static void e(
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) => AppLogger.e(message, tag: tag, error: error, stackTrace: stackTrace);
  static void s(dynamic message, {String? tag}) =>
      AppLogger.s(message, tag: tag);
}
