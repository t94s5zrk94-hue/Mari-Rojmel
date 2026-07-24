/// ===============================================================
/// Mari-Rojmel
/// Emoji Picker Dialog
///
/// Shared Emoji Picker used across the application.
///
/// Features
/// • Material 3
/// • Live Search
/// • Grouped Emojis
/// • Responsive Grid
/// • Selected Highlight
///
/// Used by:
/// • Categories
/// • Payment Modes
/// • Accounts
/// • Budgets (Future)
/// • Tags (Future)
///
/// Version : v2.0
/// ===============================================================

import 'package:flutter/material.dart';

import 'emoji_data.dart';
import 'emoji_model.dart';
import 'emoji_search.dart';

class EmojiPickerDialog extends StatefulWidget {
  final String? selectedEmoji;

  const EmojiPickerDialog({super.key, this.selectedEmoji});

  static Future<String?> show(BuildContext context, {String? selectedEmoji}) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) => EmojiPickerDialog(selectedEmoji: selectedEmoji),
    );
  }

  static Future<String?> pick(BuildContext context, {String? selectedEmoji}) {
    return show(context, selectedEmoji: selectedEmoji);
  }

  @override
  State<EmojiPickerDialog> createState() => _EmojiPickerDialogState();
}

class _EmojiPickerDialogState extends State<EmojiPickerDialog> {
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  late String _selectedEmoji;

  late List<EmojiModel> _filtered;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _selectedEmoji = widget.selectedEmoji ?? '';

    _filtered = EmojiData.emojis;

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);

    _searchController.dispose();

    _scrollController.dispose();

    super.dispose();
  }

  void _onSearchChanged() {
    final value = _searchController.text.trim();

    if (_searchQuery == value) {
      return;
    }

    _searchQuery = value;

    setState(() {
      _filtered = EmojiSearch.search(value);
    });
  }

  bool _isSelected(EmojiModel emoji) {
    return emoji.emoji == _selectedEmoji;
  }

  void _selectEmoji(EmojiModel emoji) {
    setState(() {
      _selectedEmoji = emoji.emoji;
    });
  }

  void _clearSearch() {
    if (_searchController.text.isEmpty) {
      return;
    }

    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 420,
        height: 650,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  const Text('😀', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Select Emoji',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search emoji...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.clear),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Selected',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      _selectedEmoji.isEmpty ? 'None' : _selectedEmoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(child: _buildEmojiGrid()),

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _selectedEmoji.isEmpty ? null : _submit,
                      icon: const Icon(Icons.check),
                      label: const Text('Select'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiGrid() {
    if (_filtered.isEmpty) {
      return _buildEmptyState();
    }

    final groups = <String, List<EmojiModel>>{};

    for (final emoji in _filtered) {
      groups.putIfAbsent(emoji.group, () => <EmojiModel>[]);

      groups[emoji.group]!.add(emoji);
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: groups.entries
          .map((entry) => _buildGroupSection(entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildGroupSection(String group, List<EmojiModel> emojis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Text(
            group,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: emojis.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return _buildEmojiTile(emojis[index]);
          },
        ),
      ],
    );
  }

  Widget _buildEmojiTile(EmojiModel emoji) {
    final selected = _isSelected(emoji);

    return Material(
      color: _tileBackground(selected),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _selectEmoji(emoji),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _tileBorder(selected)),
          ),
          child: Tooltip(
            message: emoji.name,
            child: Text(emoji.emoji, style: const TextStyle(fontSize: 28)),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No emojis found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with another keyword.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Color _tileBackground(bool selected) {
    if (selected) {
      return Theme.of(context).colorScheme.primaryContainer;
    }

    return Theme.of(context).colorScheme.surface;
  }

  Color _tileBorder(bool selected) {
    if (selected) {
      return Theme.of(context).colorScheme.primary;
    }

    return Theme.of(context).colorScheme.outlineVariant;
  }

  void _submit() {
    Navigator.of(context).pop(_selectedEmoji);
  }
}
