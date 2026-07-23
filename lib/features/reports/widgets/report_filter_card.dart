import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../services/report_service.dart';
import '../../../app/app_spacing.dart';

/// ==========================================================
/// Report Filter Card
///
/// Production Ready
/// Material 3
/// Responsive
/// Reusable
/// ==========================================================
class ReportFilterCard extends StatelessWidget {
  const ReportFilterCard({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.customStartDate,
    this.customEndDate,
  });

  final ReportFilter selectedFilter;
  final ValueChanged<ReportFilter> onFilterChanged;

  final DateTime? customStartDate;
  final DateTime? customEndDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.reportFilter,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChip(
                      label: AppLocalizations.of(context)!.today,
                      selected: selectedFilter.type == ReportFilterType.today,
                      onTap: () {
                        onFilterChanged(const ReportFilter.today());
                      },
                    ),
                    _buildChip(
                      label: AppLocalizations.of(context)!.thisWeek,
                      selected:
                          selectedFilter.type == ReportFilterType.thisWeek,
                      onTap: () {
                        onFilterChanged(const ReportFilter.thisWeek());
                      },
                    ),
                    _buildChip(
                      label: AppLocalizations.of(context)!.thisMonth,
                      selected:
                          selectedFilter.type == ReportFilterType.thisMonth,
                      onTap: () {
                        onFilterChanged(const ReportFilter.thisMonth());
                      },
                    ),
                    _buildChip(
                      label: AppLocalizations.of(context)!.thisYear,
                      selected:
                          selectedFilter.type == ReportFilterType.thisYear,
                      onTap: () {
                        onFilterChanged(const ReportFilter.thisYear());
                      },
                    ),
                    _buildChip(
                      label: AppLocalizations.of(context)!.custom,
                      selected: selectedFilter.type == ReportFilterType.custom,
                      onTap: () => _pickDateRange(context),
                    ),
                  ],
                ),
                if (selectedFilter.type == ReportFilterType.custom)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                    child: Text(
                      _dateRangeText(context),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();

    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 10),
      initialDateRange: customStartDate != null && customEndDate != null
          ? DateTimeRange(start: customStartDate!, end: customEndDate!)
          : null,
    );

    if (range == null) {
      return;
    }

    onFilterChanged(ReportFilter.custom(from: range.start, to: range.end));
  }

  String _dateRangeText(BuildContext context) {
    if (customStartDate == null || customEndDate == null) {
      return AppLocalizations.of(context)!.noDateRangeSelected;
    }

    return '${_formatDate(customStartDate!)}'
        ' - '
        '${_formatDate(customEndDate!)}';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}
