import 'package:flutter/material.dart';

class FilePickerRow extends StatelessWidget {
  const FilePickerRow({
    super.key,
    required this.label,
    required this.controller,
    required this.onSelect,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                readOnly: true,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onSelect,
              child: const Text('Selecciona...'),
            ),
          ],
        ),
      ],
    );
  }
}
