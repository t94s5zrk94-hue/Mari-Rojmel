import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_text_field.dart';

/// A reusable amount input field.
///
/// Features:
/// - Numeric keyboard
/// - Decimal support
/// - Currency icon
/// - Material 3 compatible
/// - Theme aware
class AppAmountField extends StatelessWidget {
  const AppAmountField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText = 'Amount',
    this.hintText = 'Enter amount',
    this.helperText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.allowDecimal = true,
    this.prefixIcon,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String labelText;
  final String hintText;
  final String? helperText;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  /// Allow decimal values.
  final bool allowDecimal;

  /// Custom prefix icon.
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(allowDecimal ? r'^\d*\.?\d{0,2}' : r'^\d*'),
        ),
      ],
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      prefixIcon: prefixIcon ?? const Icon(Icons.currency_rupee),
    );
  }
}
