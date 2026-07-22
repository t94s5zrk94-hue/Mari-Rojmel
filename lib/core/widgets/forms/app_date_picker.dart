import 'package:flutter/material.dart';

import 'app_text_field.dart';

/// A reusable Material 3 date picker field.
///
/// Features:
/// - Read-only text field
/// - Opens date picker on tap
/// - Material 3 compatible
/// - Theme aware
/// - Customizable date range
class AppDatePicker extends StatelessWidget {
  const AppDatePicker({
    super.key,
    required this.controller,
    this.labelText = 'Date',
    this.hintText = 'Select date',
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.onDateSelected,
    this.enabled = true,
    this.prefixIcon,
    this.validator,
  });

  final TextEditingController controller;

  final String labelText;
  final String hintText;

  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  final ValueChanged<DateTime>? onDateSelected;

  final bool enabled;

  final Widget? prefixIcon;

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      readOnly: true,
      enabled: enabled,
      validator: validator,
      prefixIcon: prefixIcon ?? const Icon(Icons.calendar_today_outlined),
      suffixIcon: const Icon(Icons.arrow_drop_down),
      onTap: () async {
        if (!enabled) return;

        final now = DateTime.now();

        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate ?? now,
          firstDate: firstDate ?? DateTime(2000),
          lastDate: lastDate ?? DateTime(2100),
        );

        if (pickedDate == null) return;

        controller.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/"
            "${pickedDate.month.toString().padLeft(2, '0')}/"
            "${pickedDate.year}";

        onDateSelected?.call(pickedDate);
      },
    );
  }
}
