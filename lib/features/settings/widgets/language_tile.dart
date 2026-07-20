// ===============================================================
// Mari-Rojmel
// Language Tile Widget
//
// Reusable language selection tile.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/material.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: selected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}
