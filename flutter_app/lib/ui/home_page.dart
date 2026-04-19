import 'package:flutter/material.dart';
import 'panels/decrypt_panel.dart';
import 'panels/encrypt_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            Expanded(child: EncryptPanel()),
            SizedBox(width: 16),
            Expanded(child: DecryptPanel()),
          ],
        ),
      ),
    );
  }
}