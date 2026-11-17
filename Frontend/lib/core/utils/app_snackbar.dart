import 'package:taskflow/core/consts/colours.dart';
import 'package:taskflow/core/consts/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  AppSnackbar._();

  /// Normalizes user-facing messages (especially validation errors):
  /// trims, collapses repeated whitespace, and capitalizes the first letter.
  static String _format(String message) {
    final normalized = message.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty) return normalized;
    return normalized[0].toUpperCase() + normalized.substring(1);
  }

  static void success(String message) {
    _show(
      title: 'Success',
      message: message,
      color: Colours.success,
      tint: Colours.successLight,
      icon: Icons.check_circle_outline,
    );
  }

  static void error(String message) {
    _show(
      title: 'Error',
      message: message,
      color: Colours.error,
      tint: Colours.errorLight,
      icon: Icons.error_outline,
    );
  }

  static void info(String message) {
    _show(
      title: 'Info',
      message: message,
      color: Colours.info,
      tint: Colours.infoLight,
      icon: Icons.info_outline,
    );
  }

  static void warning(String message) {
    _show(
      title: 'Warning',
      message: message,
      color: Colours.warning,
      tint: Colours.warningLight,
      icon: Icons.warning_amber_outlined,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color color,
    required Color tint,
    required IconData icon,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style: const TextStyle(
          fontFamily: Fonts.primary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colours.text,
        ),
      ),
      messageText: Text(
        _format(message),
        style: const TextStyle(
          fontFamily: Fonts.primary,
          fontWeight: FontWeight.w400,
          fontSize: 13,
          height: 1.35,
          color: Colours.mutedText,
        ),
      ),
      icon: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.only(left: 2),
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      shouldIconPulse: false,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: Colours.surface,
      borderColor: Colours.border,
      borderWidth: 1,
      borderRadius: 14,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 250),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      boxShadows: const [
        BoxShadow(
          color: Color(0x1A0F172A),
          blurRadius: 24,
          offset: Offset(0, 10),
        ),
      ],
      barBlur: 0,
      mainButton: TextButton(
        onPressed: Get.closeCurrentSnackbar,
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(0, 36),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Dismiss',
          style: TextStyle(
            fontFamily: Fonts.primary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
