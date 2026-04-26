import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

String get userHomeDirectory {
  return Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
}

String get sshDirectory {
  return '$userHomeDirectory/.ssh';
}

String get parentOfCurrentDirectory {
  return p.dirname(Directory.current.path);
}

void showMessage(BuildContext context, String message) {
  _showFeedback(context, message, isSuccess: true);
}

void showError(BuildContext context, String message) {
  _showFeedback(context, message, isSuccess: false);
}

void _showFeedback(
  BuildContext context,
  String message, {
  required bool isSuccess,
}) {
  final messenger = ScaffoldMessenger.of(context);
  final theme = Theme.of(context);
  final indicatorColor = isSuccess ? Colors.green : Colors.redAccent;

  messenger
    ..hideCurrentSnackBar()
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.black,
        showCloseIcon: true,
        closeIconColor: theme.colorScheme.onSurface,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
}
