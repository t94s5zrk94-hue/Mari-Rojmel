import 'package:flutter/material.dart';

class QuickEntryCard extends StatelessWidget {
  const QuickEntryCard({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        labelText: 'Quick Entry',
        hintText: 'Example: 500 Milk',
        prefixIcon: Icon(Icons.flash_on),
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
