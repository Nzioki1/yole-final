import 'package:intl/intl.dart';

class MpesaCaps {
  static const int perTxnKes = 250000;
  static const int dailyKes = 500000;
}

/// Next midnight in Africa/Nairobi as a UTC DateTime.
/// EAT = UTC+3 (no DST), so we can compute safely without a tz package.
DateTime nextMidnightNairobiUtc({DateTime? nowUtc}) {
  final utc = nowUtc ?? DateTime.now().toUtc();
  final eat = utc.add(const Duration(hours: 3)); // local EAT
  final nextLocalMidnight = DateTime(
    eat.year,
    eat.month,
    eat.day,
  ).add(const Duration(days: 1));
  // convert that local midnight back to UTC
  return nextLocalMidnight.subtract(const Duration(hours: 3));
}

String formatShortCountdown(Duration d) {
  if (d.inMinutes < 60) return '${d.inMinutes}m';
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  return '${h}h ${m}m';
}

String formatAbsoluteEAT(DateTime resetUtc) {
  final eat = resetUtc.add(const Duration(hours: 3));
  final fmt = DateFormat('h:mm a'); // e.g., 12:00 AM
  return '${fmt.format(eat)} EAT';
}

/// Derive both short and long hints from a reset instant.
({String shortHint, String longRel, String longAbs}) buildResetHints(
  DateTime resetUtc, {
  DateTime? nowUtc,
}) {
  final now = nowUtc ?? DateTime.now().toUtc();
  final diff = resetUtc.isAfter(now) ? resetUtc.difference(now) : Duration.zero;
  final short = 'Resets in ${formatShortCountdown(diff)}';
  final longRel = 'Resets in ${formatShortCountdown(diff)}';
  final longAbs = 'Next available at ${formatAbsoluteEAT(resetUtc)}';
  return (shortHint: short, longRel: longRel, longAbs: longAbs);
}
