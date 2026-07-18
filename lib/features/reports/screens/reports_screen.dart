// ===============================================================
// Mari-Rojmel
// Reports Screen
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/material.dart';

import '../models/report_summary.dart';
import '../services/report_service.dart';
import '../widgets/report_filter_card.dart';
import '../widgets/report_summary_card.dart';
import '../widgets/category_report.dart';
import '../widgets/payment_mode_report.dart';
import '../models/category_report_item.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ReportsService _reportsService = ReportsService.instance;

  ReportFilter _selectedFilter = const ReportFilter.thisMonth();

  ReportSummary? _summary;

  List<CategoryReportItem> _categoryReport = [];

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadReports();
  }

  Future<void> _loadReports() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final summary = await _reportsService.getSummary(filter: _selectedFilter);

      final categoryReport = await _reportsService.getCategoryReport(
        filter: _selectedFilter,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _summary = summary;
        _categoryReport = categoryReport;
        _isLoading = false;
      });
    } on Exception catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    await _loadReports();
  }

  Future<void> _changeFilter(ReportFilter filter) async {
    setState(() {
      _selectedFilter = filter;
    });

    await _loadReports();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reports'), centerTitle: false),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 72,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unable to load reports',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final summary = _summary!;

    return Scaffold(
      appBar: AppBar(title: const Text('Reports'), centerTitle: false),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ReportFilterCard(
              selectedFilter: _selectedFilter,
              customStartDate: _selectedFilter.startDate,
              customEndDate: _selectedFilter.endDate,
              onFilterChanged: _changeFilter,
            ),

            const SizedBox(height: 20),

            ReportSummaryCard(summary: summary),

            const SizedBox(height: 20),

            //CategoryReport(reportData: _categoryReport),
            const SizedBox(height: 20),

            //PaymentModeReport(reportData: _paymentModeReport),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
