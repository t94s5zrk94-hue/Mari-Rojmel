import 'dart:async';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';
import '../../../core/enums/transaction_type.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Screen responsible for managing Categories in the Mari-Rojmel application.
/// Implementation finalized to production-grade standards.
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.repository});
  final ICategoryRepository repository;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

enum _MenuAction { edit, delete }

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<CategoryModel> _categories = [];
  bool _isLoading = true;
  //bool _hasChanges = false;
  String? _errorMessage;
  Timer? _debounce;
  TransactionType _selectedType = TransactionType.expense;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await widget.repository.getActive(
        transactionType: _selectedType,
      );
      if (!mounted) return;
      setState(() {
        _categories = data;
        _isLoading = false;
      });
    } on Exception catch (e, stackTrace) {
      debugPrint('CATEGORY LOAD ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {VoidCallback? onUndo}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: onUndo != null
            ? SnackBarAction(
                label: AppLocalizations.of(context)!.undo,
                onPressed: onUndo,
              )
            : null,
      ),
    );
  }

  Future<void> _showAddDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final focusNode = FocusNode();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addCategory),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            focusNode: focusNode,
            autofocus: true,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.categoryName,
              border: const OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? AppLocalizations.of(context)!.nameRequired
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final model = CategoryModel.empty().copyWith(
                  name: nameController.text.trim(),
                  transactionType: _selectedType,
                );
                await widget.repository.insert(model);
                if (!ctx.mounted) return;
                Navigator.of(ctx).pop(true);
              } on DuplicateCategoryException {
                _showSnackBar(l10n.categoryAlreadyExists);
              } on Exception catch (e, stackTrace) {
                debugPrint('CATEGORY ADD ERROR: $e');
                debugPrintStack(stackTrace: stackTrace);

                _showSnackBar(l10n.categoryAddFailed);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      Future.microtask(() async {
        if (!mounted) return;

        await _loadData();

        if (!mounted) return;

        _showSnackBar(l10n.categoryAdded);
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.dispose();
    });
    focusNode.dispose();
  }

  Future<void> _showEditDialog(CategoryModel model) async {
    final l10n = AppLocalizations.of(context)!;
    if (model.isDefault) {
      _showSnackBar(AppLocalizations.of(context)!.defaultCategoryProtected);
      return;
    }

    final nameController = TextEditingController(text: model.name);
    final formKey = GlobalKey<FormState>();
    final focusNode = FocusNode();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editCategory),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            focusNode: focusNode,
            autofocus: true,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.categoryName,
              border: const OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? AppLocalizations.of(context)!.nameRequired
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                await widget.repository.update(
                  model.copyWith(name: nameController.text.trim()),
                );

                if (!ctx.mounted) return;

                Navigator.of(ctx).pop(true);
              } on DuplicateCategoryException {
                _showSnackBar(l10n.categoryNameTaken);
              } on Exception {
                _showSnackBar(l10n.categoryUpdateFailed);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.dispose();
    });
    focusNode.dispose();

    if (result == true) {
      await _loadData();

      if (!mounted) return;

      _showSnackBar(AppLocalizations.of(context)!.categoryUpdated);
    }
  }

  Future<void> _handleDelete(CategoryModel model) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteCategory),
        content: Text(
          AppLocalizations.of(context)!.deleteCategoryConfirmation(model.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      if (model.id == null) {
        _showSnackBar(l10n.invalidCategory);
        return;
      }

      try {
        await widget.repository.softDelete(model.id!);

        if (!mounted) return;

        await _loadData();

        if (!mounted) return;

        _showSnackBar(
          l10n.categoryDeleted(model.name),

          onUndo: () async {
            try {
              await widget.repository.restore(model.id!);

              if (!mounted) return;

              await _loadData();

              if (!mounted) return;

              _showSnackBar(l10n.categoryRestored);
            } on Exception {
              if (!mounted) return;

              _showSnackBar(l10n.unableToRestoreCategory);
            }
          },
        );
      } on DefaultCategoryException {
        if (!mounted) return;

        _showSnackBar(l10n.defaultCategoryDeleteProtected);
      } on Exception {
        if (!mounted) return;

        _showSnackBar(l10n.categoryDeleteFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppLocalizations.of(context)!.categories} (${_categories.length})',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.addCategory,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintText: AppLocalizations.of(context)!.searchCategories,
              onChanged: (val) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () async {
                  final l10n = AppLocalizations.of(context)!;
                  try {
                    final results = val.trim().isEmpty
                        ? await widget.repository.getActive(
                            transactionType: _selectedType,
                          )
                        : await widget.repository.search(
                            val.trim(),
                            transactionType: _selectedType,
                          );
                    if (mounted) setState(() => _categories = results);
                  } catch (_) {
                    if (mounted) _showSnackBar(l10n.searchError);
                  }
                });
              },
              trailing: _searchController.text.isNotEmpty
                  ? [
                      IconButton(
                        tooltip: AppLocalizations.of(context)!.clearSearch,
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchFocusNode.unfocus();
                          _loadData();
                        },
                      ),
                    ]
                  : [],
            ),
          ),
          SegmentedButton<TransactionType>(
            segments: [
              ButtonSegment(
                value: TransactionType.expense,
                label: Text(AppLocalizations.of(context)!.expense),
              ),
              ButtonSegment(
                value: TransactionType.income,
                label: Text(AppLocalizations.of(context)!.income),
              ),
            ],
            selected: {_selectedType},
            onSelectionChanged: (val) {
              setState(() => _selectedType = val.first);
              _loadData();
            },
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : _errorMessage != null
                ? _buildErrorView()
                : _categories.isEmpty
                ? _buildEmptyView()
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (ctx, i) => _buildCard(_categories[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(CategoryModel model) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(model.color),
        child: Text(model.icon),
      ),
      title: Semantics(
        label: AppLocalizations.of(context)!.categoryName,
        child: Text(model.name),
      ),
      subtitle: Wrap(
        spacing: 8,
        children: [
          Chip(
            label: Text(
              model.transactionType.name.toUpperCase(),
              style: const TextStyle(fontSize: 10),
            ),
            visualDensity: VisualDensity.compact,
          ),
          if (model.isDefault)
            Chip(
              label: Text(
                AppLocalizations.of(context)!.defaultLabel,
                style: const TextStyle(fontSize: 10),
              ),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
      trailing: Tooltip(
        message: model.isDefault
            ? AppLocalizations.of(context)!.protectedLabel
            : AppLocalizations.of(context)!.actions,
        child: PopupMenuButton<_MenuAction>(
          enabled: !model.isDefault,
          onSelected: (action) => action == _MenuAction.edit
              ? _showEditDialog(model)
              : _handleDelete(model),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: _MenuAction.edit,
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text(AppLocalizations.of(context)!.edit),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: _MenuAction.delete,
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text(AppLocalizations.of(context)!.delete),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 72,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.unableToLoadCategories,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.categoryLoadError,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.noCategoriesYet,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.createFirstCategory,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.addCategory),
            ),
          ],
        ),
      ),
    );
  }
}
