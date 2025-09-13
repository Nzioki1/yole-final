import 'package:intl/intl.dart';

/// M-Pesa countdown utility for Africa/Nairobi timezone
///
/// Computes reset times at 00:00 Africa/Nairobi (local M-Pesa day boundary)
/// Provides both short inline and long form countdown formats
class MpesaCountdown {
  /// Get the next reset time (00:00 Africa/Nairobi)
  static DateTime getNextReset() {
    final now = DateTime.now().toUtc();
    final nairobi = now.toLocal().toUtc().add(
      const Duration(hours: 3),
    ); // UTC+3

    // Get today's midnight in Nairobi timezone
    final todayMidnight = DateTime(nairobi.year, nairobi.month, nairobi.day);

    // If we're past midnight today, get tomorrow's midnight
    if (nairobi.isAfter(todayMidnight)) {
      return todayMidnight.add(const Duration(days: 1));
    }

    return todayMidnight;
  }

  /// Get short inline countdown hint for banners
  /// Format: "Resets in 4h 23m" or "Resets in 23m"
  /// Minimum granularity: 1 minute (for accessibility)
  static String getShortCountdown() {
    final nextReset = getNextReset();
    final now = DateTime.now().toUtc();
    final nairobi = now.toLocal().toUtc().add(const Duration(hours: 3));

    final difference = nextReset.difference(nairobi);
    final totalMinutes = difference.inMinutes;

    // Round to nearest minute for accessibility (min granularity = 1 minute)
    final roundedMinutes = totalMinutes.clamp(1, totalMinutes);
    final hours = roundedMinutes ~/ 60;
    final minutes = roundedMinutes % 60;

    String timeShort;
    if (hours >= 1) {
      timeShort = '${hours}h ${minutes}m';
    } else {
      timeShort = '${minutes}m';
    }

    // For now, return the formatted string directly
    // In a full implementation, this would use AppLocalizations
    return 'Resets in $timeShort';
  }

  /// Get long form countdown for Cap-Details screen
  /// Returns both relative and absolute times
  /// Minimum granularity: 1 minute (for accessibility)
  static MpesaCountdownInfo getLongCountdown() {
    final nextReset = getNextReset();
    final now = DateTime.now().toUtc();
    final nairobi = now.toLocal().toUtc().add(const Duration(hours: 3));

    final difference = nextReset.difference(nairobi);
    final totalMinutes = difference.inMinutes;

    // Round to nearest minute for accessibility (min granularity = 1 minute)
    final roundedMinutes = totalMinutes.clamp(1, totalMinutes);
    final hours = roundedMinutes ~/ 60;
    final minutes = roundedMinutes % 60;

    // Format absolute time
    final formatter = DateFormat('h:mm a');
    final absoluteTime = formatter.format(nextReset);

    final timeFull = '${hours}h ${minutes}m';

    return MpesaCountdownInfo(
      relative: 'Resets in $timeFull',
      absolute: 'Next available at $absoluteTime EAT',
    );
  }

  /// Check if current time is within M-Pesa business hours
  /// M-Pesa typically operates 24/7, but this can be used for additional validation
  static bool isWithinBusinessHours() {
    // M-Pesa operates 24/7, so always return true
    // This method can be extended if business hours restrictions are needed
    return true;
  }
}

/// Countdown information for Cap-Details screen
class MpesaCountdownInfo {
  const MpesaCountdownInfo({required this.relative, required this.absolute});

  final String relative;
  final String absolute;
}
