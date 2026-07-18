import '../models/category_report_item.dart';
import '../repositories/report_repository.dart';
import '../models/report_summary.dart';

/// ==========================================================
/// Report Filter
/// ==========================================================

enum ReportFilterType { today, thisWeek, thisMonth, thisYear, custom }

/// ==========================================================
/// Date Range Filter
/// ==========================================================

class ReportFilter {
  const ReportFilter({required this.type, this.startDate, this.endDate});

  final ReportFilterType type;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReportFilter.today()
    : type = ReportFilterType.today,
      startDate = null,
      endDate = null;

  const ReportFilter.thisWeek()
    : type = ReportFilterType.thisWeek,
      startDate = null,
      endDate = null;

  const ReportFilter.thisMonth()
    : type = ReportFilterType.thisMonth,
      startDate = null,
      endDate = null;

  const ReportFilter.thisYear()
    : type = ReportFilterType.thisYear,
      startDate = null,
      endDate = null;

  const ReportFilter.custom({required DateTime from, required DateTime to})
    : type = ReportFilterType.custom,
      startDate = from,
      endDate = to;
}

/// ==========================================================
/// Reports Service
/// ==========================================================

class ReportsService {
  ReportsService._({ReportRepository? repository})
    : _repository = repository ?? ReportRepository();

  static final ReportsService instance = ReportsService._();

  final ReportRepository _repository;

  /// ==========================================================
  /// Public APIs
  /// ==========================================================
  Future<ReportSummary> getSummary({required ReportFilter filter}) async {
    final (startDate, endDate) = _resolveDateRange(filter);

    return _repository.getReportSummary(startDate: startDate, endDate: endDate);
  }

  Future<List<CategoryReportItem>> getCategoryReport({
    required ReportFilter filter,
  }) async {
    final (startDate, endDate) = _resolveDateRange(filter);

    return _repository.getCategoryReport(
      startDate: startDate,
      endDate: endDate,
    );
  }

  (DateTime?, DateTime?) _resolveDateRange(ReportFilter filter) {
    final now = DateTime.now();

    switch (filter.type) {
      case ReportFilterType.today:
        final start = DateTime(now.year, now.month, now.day);
        return (start, start.add(const Duration(days: 1)));

      case ReportFilterType.thisWeek:
        final start = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: now.weekday - 1));

        return (start, start.add(const Duration(days: 7)));

      case ReportFilterType.thisMonth:
        return (
          DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 1),
        );

      case ReportFilterType.thisYear:
        return (DateTime(now.year, 1, 1), DateTime(now.year + 1, 1, 1));

      case ReportFilterType.custom:
        return (filter.startDate, filter.endDate);
    }
  }
}
