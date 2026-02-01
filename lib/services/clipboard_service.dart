import 'package:flutter/services.dart';

/// Service for clipboard operations.
/// Equivalent to WPF's CopyStringCommand with retry logic.
class ClipboardService {
  static const int _maxRetries = 10;
  static const Duration _retryDelay = Duration(milliseconds: 120);

  /// Copies text to clipboard with retry logic for robustness.
  Future<bool> copyToClipboard(String text) async {
    if (text.trim().isEmpty) return false;

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        await Clipboard.setData(ClipboardData(text: text));
        return true;
      } catch (_) {
        if (attempt < _maxRetries - 1) {
          await Future.delayed(_retryDelay);
        }
      }
    }
    return false;
  }
}
