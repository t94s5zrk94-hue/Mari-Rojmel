import 'package:flutter/material.dart';

class EmojiPickerDialog extends StatelessWidget {
  const EmojiPickerDialog({super.key, this.selected = '📁'});

  final String selected;

  static const List<String> emojis = [
    '📁',
    '🍔',
    '🥤',
    '☕',
    '🍕',
    '🛒',
    '🚗',
    '⛽',
    '🏠',
    '💡',
    '📱',
    '💊',
    '💼',
    '💰',
    '🏦',
    '🎓',
    '🎁',
    '🎉',
    '✈️',
    '🚌',
    '🚕',
    '❤️',
    '👕',
    '🐶',
    '📚',
    '🎬',
    '🎮',
    '🧾',
  ];
  static Future<String?> pick(BuildContext context, {String selected = '📁'}) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) => EmojiPickerDialog(selected: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Emoji'),

      content: SizedBox(
        width: 360,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: emojis.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final emoji = emojis[index];

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.pop(context, emoji);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: emoji == selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            );
          },
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
