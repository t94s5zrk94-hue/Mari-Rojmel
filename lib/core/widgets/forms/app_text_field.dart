import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable Material 3 text field used throughout the application.
///
/// Features:
/// - Material 3 compatible
/// - Theme aware
/// - Supports validation
/// - Supports prefix/suffix icons
/// - Supports input formatters
/// - Supports multiline
/// - Supports obscure text
/// - Reusable across all forms
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.obscureText = false,
    this.initialValue,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? initialValue;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final List<TextInputFormatter>? inputFormatters;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;

  final int maxLines;
  final int? minLines;
  final int? maxLength;

  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final bool obscureText;

  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? null : minLines,
      maxLength: maxLength,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
