/// Standard animation durations used throughout the application.
///
/// Avoid hardcoded durations such as:
/// Duration(milliseconds: 300)
///
/// Use AppDurations instead.
abstract final class AppDurations {
  AppDurations._();

  /// Instant
  static const Duration instant = Duration.zero;

  /// Very fast
  static const Duration veryFast = Duration(milliseconds: 100);

  /// Fast
  static const Duration fast = Duration(milliseconds: 200);

  /// Medium (default)
  static const Duration medium = Duration(milliseconds: 300);

  /// Slow
  static const Duration slow = Duration(milliseconds: 500);

  /// Very slow
  static const Duration verySlow = Duration(milliseconds: 800);

  /// Page transition
  static const Duration pageTransition = medium;

  /// Dialog animation
  static const Duration dialog = fast;

  /// Snackbar animation
  static const Duration snackbar = medium;
}
