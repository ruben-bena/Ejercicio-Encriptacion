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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}
