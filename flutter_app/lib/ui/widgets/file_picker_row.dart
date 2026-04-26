import 'package:flutter/material.dart';

class FilePickerRow extends StatelessWidget {
  const FilePickerRow({
    super.key,
    required this.label,
    required this.controller,
    required this.onSelect,
    this.icon = Icons.folder_open,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onSelect;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bool hasValue = controller.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(4),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              prefixIcon: Icon(icon),
              suffixIcon: const Icon(Icons.folder_open),
            ),
            child: Text(
              hasValue ? controller.text : 'Seleccionar archivo…',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: hasValue
                    ? Theme.of(context).textTheme.bodyMedium?.color
                    : Colors.white54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
