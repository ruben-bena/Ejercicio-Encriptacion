import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const EncryptionApp());
}

class EncryptionApp extends StatelessWidget {
  const EncryptionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'RSA Tool',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}