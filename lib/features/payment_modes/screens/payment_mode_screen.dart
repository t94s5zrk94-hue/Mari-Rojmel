import 'dart:async';

import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/payment_mode_model.dart';
import '../repositories/payment_mode_repository.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_spacing.dart';
import '../../../app/app_radius.dart';
import '../../../app/app_sizes.dart';

class PaymentModeScreen extends StatefulWidget {
  const PaymentModeScreen({super.key, required this.repository});

  final IPaymentModeRepository repository;

  @override
  State<PaymentModeScreen> createState() => _PaymentModeScreenState();
}

enum _MenuAction { edit, delete }

class _PaymentModeScreenState extends State<PaymentModeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  List<PaymentModeModel> _paymentModes = [];

  bool _isLoading = true;

  String? _errorMessage;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchTextChanged);

    _loadData();
  }

  @override
  void dispose() {
    _debounce?.cancel();

    _searchController.removeListener(_onSearchTextChanged);

    _searchController.dispose();

    _searchFocusNode.dispose();

    super.dispose();
  }

  void _onSearchTextChanged() {
    if (!mounted) return;

    setState(() {});
  }

  Future<void> _clearSearch() async {
    _debounce?.cancel();

    if (_searchController.text.isEmpty) {
      return;
    }

    _searchController.clear();

    await _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await widget.repository.getActive();

      if (!mounted) return;

      setState(() {
        _paymentModes = data;
        _isLoading = false;
      });
    } on Exception catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleSearch(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final keyword = value.trim();

        final result = keyword.isEmpty
            ? await widget.repository.getActive()
            : await widget.repository.search(keyword);

        if (!mounted) return;

        setState(() {
          _paymentModes = result;
        });
      } on Exception {
        if (!mounted) return;

        _showSnackBar(AppLocalizations.of(context)!.searchError);
      }
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showAddDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.extraLarge),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(l10n.addPaymentMode),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,

              autofocus: true,
              maxLength: 50,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.paymentModeName,
                hintText: l10n.paymentModeNameHint,
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.paymentModeRequired;
                }

                return null;
              },
              onFieldSubmitted: (_) {
                FocusScope.of(dialogContext).unfocus();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                FocusScope.of(dialogContext).unfocus();

                try {
                  final model = PaymentModeModel(
                    id: null,
                    name: nameController.text.trim(),
                    icon: '💳',
                    color: 0xFF4CAF50,
                    isDefault: false,
                    isActive: true,
                    sortOrder: _paymentModes.length + 1,
                  );

                  final success = await widget.repository.insert(model);

                  if (!dialogContext.mounted) return;

                  FocusManager.instance.primaryFocus?.unfocus();

                  await Future<void>.delayed(const Duration(milliseconds: 50));

                  if (!dialogContext.mounted) return;

                  Navigator.of(dialogContext).pop(success);
                } on DuplicatePaymentModeException {
                  _showSnackBar(l10n.paymentModeAlreadyExists);
                } catch (e) {
                  if (!dialogContext.mounted) return;

                  _showSnackBar(l10n.paymentModeAddFailed);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );

    try {
      if (result == true) {
        await _loadData();

        if (!mounted) return;

        _showSnackBar(l10n.paymentModeAdded);
      }
    } finally {
      nameController.dispose();
    }
  }

  Future<void> _showEditDialog(PaymentModeModel model) async {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: model.name);

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.extraLarge),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(l10n.editPaymentMode),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              autofocus: true,
              maxLength: 50,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.paymentModeName,
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.paymentModeRequired;
                }

                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                FocusScope.of(dialogContext).unfocus();

                try {
                  final updatedModel = PaymentModeModel(
                    id: model.id,
                    name: nameController.text.trim(),
                    icon: model.icon,
                    color: model.color,
                    isDefault: model.isDefault,
                    isActive: model.isActive,
                    sortOrder: model.sortOrder,
                  );

                  final success = await widget.repository.update(updatedModel);

                  if (!dialogContext.mounted) return;

                  Navigator.of(dialogContext).pop(success);
                } on DuplicatePaymentModeException {
                  _showSnackBar(l10n.paymentModeAlreadyExists);
                } on DefaultPaymentModeException {
                  _showSnackBar(l10n.paymentModeUpdateFailed);
                } on Exception {
                  _showSnackBar(l10n.paymentModeUpdateFailed);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );

    try {
      if (result == true) {
        await _loadData();

        if (!mounted) return;

        _showSnackBar(l10n.paymentModeAdded);
      }
    } finally {
      nameController.dispose();
    }
  }

  Future<void> _handleDelete(PaymentModeModel model) async {
    final l10n = AppLocalizations.of(context)!;
    if (model.id == null) {
      _showSnackBar(l10n.invalidPaymentMode);
      return;
    }

    try {
      final success = await widget.repository.softDelete(model.id!);

      if (!mounted) return;

      if (!success) {
        _showSnackBar(l10n.paymentModeDeleteFailed);
        return;
      }

      await _loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.paymentModeDeleted(model.name)),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () async {
              try {
                await widget.repository.restore(model.id!);

                if (!mounted) return;

                await _loadData();

                if (!mounted) return;

                _showSnackBar(l10n.paymentModeRestored);
              } on Exception {
                _showSnackBar(l10n.paymentModeRestoreFailed);
              }
            },
          ),
        ),
      );
    } on DefaultPaymentModeException {
      _showSnackBar(l10n.defaultPaymentModeDeleteProtected);
    } on Exception {
      _showSnackBar(l10n.paymentModeDeleteFailed);
    }
  }

  Widget _buildSearchBar() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: SearchBar(
      controller: _searchController,
      focusNode: _searchFocusNode,
      hintText: AppLocalizations.of(context)!.searchPaymentModes,
      leading: const Icon(Icons.search),
      trailing: _searchController.text.isNotEmpty
          ? [
              IconButton(
                tooltip: AppLocalizations.of(context)!.clearSearch,
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
              ),
            ]
          : null,
      onChanged: _handleSearch,
    ),
  );

  Widget _buildList() => RefreshIndicator(
    onRefresh: _loadData,
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: _paymentModes.length,
      itemBuilder: (context, index) {
        return _buildCard(_paymentModes[index]);
      },
    ),
  );

  Widget _buildCard(PaymentModeModel model) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      child: ListTile(
        leading: Text(model.icon, style: const TextStyle(fontSize: 24)),
        title: Text(model.name),
        subtitle: model.isDefault
            ? Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(
                    AppLocalizations.of(context)!.defaultLabel,
                    style: TextStyle(fontSize: 10),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              )
            : null,
        trailing: Tooltip(
          message: model.isDefault
              ? AppLocalizations.of(context)!.protectedLabel
              : AppLocalizations.of(context)!.actions,
          child: PopupMenuButton<_MenuAction>(
            onSelected: (action) {
              switch (action) {
                case _MenuAction.edit:
                  if (model.isDefault) return;
                  _showEditDialog(model);
                  break;

                case _MenuAction.delete:
                  if (model.isDefault) return;
                  _handleDelete(model);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<_MenuAction>(
                value: _MenuAction.edit,
                enabled: !model.isDefault,
                child: ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text(AppLocalizations.of(context)!.edit),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem<_MenuAction>(
                value: _MenuAction.delete,
                enabled: !model.isDefault,
                child: ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(AppLocalizations.of(context)!.delete),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 56, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.paymentModeLoadError,
            style: const TextStyle(
              fontSize: AppSizes.title,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(_errorMessage ?? 'Unknown error', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    ),
  );

  Widget _buildEmptyView() => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 56, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noPaymentModesYet,
            style: const TextStyle(
              fontSize: AppSizes.title,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.createFirstPaymentMode,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.addPaymentMode),
          ),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppLocalizations.of(context)!.paymentModes} (${_paymentModes.length})',
        ),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: AppLocalizations.of(context)!.addPaymentMode,
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : _errorMessage != null
                    ? _buildErrorView()
                    : _paymentModes.isEmpty
                    ? _buildEmptyView()
                    : _buildList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
