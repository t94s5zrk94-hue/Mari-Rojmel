import 'package:flutter/material.dart';

/// Standard icons used throughout the application.
///
/// Avoid using Icons.xxx directly in UI code.
/// Use AppIcons instead for consistency.
abstract final class AppIcons {
  AppIcons._();

  // Navigation
  static const IconData home = Icons.home_rounded;
  static const IconData dashboard = Icons.dashboard_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData profile = Icons.person_rounded;

  // Transactions
  static const IconData income = Icons.arrow_downward_rounded;
  static const IconData expense = Icons.arrow_upward_rounded;
  static const IconData transfer = Icons.swap_horiz_rounded;

  // Actions
  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData save = Icons.save_rounded;

  // Status
  static const IconData success = Icons.check_circle_outline_rounded;
  static const IconData error = Icons.error_outline_rounded;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData info = Icons.info_outline_rounded;

  // Forms
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData amount = Icons.currency_rupee_rounded;
  static const IconData category = Icons.category_rounded;
  static const IconData paymentMode = Icons.account_balance_wallet_rounded;

  // Misc
  static const IconData empty = Icons.inbox_outlined;
  static const IconData more = Icons.more_vert_rounded;
  static const IconData back = Icons.arrow_back_rounded;
  static const IconData forward = Icons.arrow_forward_rounded;
}
