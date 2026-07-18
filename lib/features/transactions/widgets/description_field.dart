import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({super.key, required this.controller, this.onChanged});

  final TextEditingController controller;

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 2,
      textInputAction: TextInputAction.newline,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Enter description (Optional)',
        prefixIcon: Icon(Icons.notes),
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
