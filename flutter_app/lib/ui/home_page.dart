import 'package:flutter/material.dart';
import 'panels/decrypt_panel.dart';
import 'panels/encrypt_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Herramienta RSA')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(child: EncryptPanel()),
            SizedBox(width: 24),
            Expanded(child: DecryptPanel()),
          ],
        ),
      ),
    );
  }
}