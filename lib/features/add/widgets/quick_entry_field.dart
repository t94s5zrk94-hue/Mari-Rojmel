import 'package:flutter/material.dart';

class QuickEntryField extends StatelessWidget {
  final TextEditingController controller;

  const QuickEntryField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      maxLines: 3,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Example:\n100 milk\n500 પેટ્રોલ',
      ),
    );
  }
}