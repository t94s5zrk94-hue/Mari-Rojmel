import 'package:flutter/material.dart';

import '../services/report_service.dart';

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
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {

            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Filter',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChip(
                      label: 'Today',
                      selected: selectedFilter.type ==
                          ReportFilterType.today,
                      onTap: () {
                        onFilterChanged(
                          const ReportFilter.today(),
                        );
                      },
                    ),
                    _buildChip(
                      label: 'This Week',
                      selected: selectedFilter.type ==
                          ReportFilterType.thisWeek,
                      onTap: () {
                        onFilterChanged(
                          const ReportFilter.thisWeek(),
                        );
                      },
                    ),
                    _buildChip(
                      label: 'This Month',
                      selected: selectedFilter.type ==
                          ReportFilterType.thisMonth,
                      onTap: () {
                        onFilterChanged(
                          const ReportFilter.thisMonth(),
                        );
                      },
                    ),
                    _buildChip(
                      label: 'This Year',
                      selected: selectedFilter.type ==
                          ReportFilterType.thisYear,
                      onTap: () {
                        onFilterChanged(
                          const ReportFilter.thisYear(),
                        );
                      },
                    ),
                    _buildChip(
                      label: 'Custom',
                      selected: selectedFilter.type ==
                          ReportFilterType.custom,
                      onTap: () => _pickDateRange(context),
                    ),
                  ],
                ),
                if (selectedFilter.type ==
                    ReportFilterType.custom)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16),
                    child: Text(
                      _dateRangeText(),
                      style:
                          theme.textTheme.bodyMedium,
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
    );
  }
    Future<void> _pickDateRange(
    BuildContext context,
  ) async {
    final now = DateTime.now();

    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 10),
      initialDateRange: customStartDate != null &&
              customEndDate != null
          ? DateTimeRange(
              start: customStartDate!,
              end: customEndDate!,
            )
          : null,
    );

    if (range == null) {
      return;
    }

    onFilterChanged(
      ReportFilter.custom(
        from: range.start,
        to: range.end,
      ),
    );
  }

  String _dateRangeText() {
    if (customStartDate == null ||
        customEndDate == null) {
      return 'No date range selected';
    }

    return '${_formatDate(customStartDate!)}'
        ' - '
        '${_formatDate(customEndDate!)}';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month =
        date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}