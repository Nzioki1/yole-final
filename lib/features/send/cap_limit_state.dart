import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/limits.dart';

enum CapBreach { none, perTxn, daily }

class CapStatus {
  final CapBreach breach;
  final String? inlineTitle;
  final String? inlineBody; // may include {reset_hint} already resolved
  final String? resetShort; // e.g., "Resets in 4h 23m"
  final String? resetLongRel; // e.g., "Resets in 4h 23m"
  final String? resetLongAbs; // e.g., "Next available at 12:00 AM EAT"
  const CapStatus({
    required this.breach,
    this.inlineTitle,
    this.inlineBody,
    this.resetShort,
    this.resetLongRel,
    this.resetLongAbs,
  });
  static const none = CapStatus(breach: CapBreach.none);
}

/// Inputs this helper expects (wire these from your existing state):
/// - txKes: estimated payable KES for THIS transaction when using M-Pesa (nullable if not yet known).
/// - dailyUsedKes: today's cumulative KES already processed via M-Pesa (authoritative from your server; UI hint if not exact).
final txKesProvider = StateProvider<double?>(
  (_) => null,
); // <-- REPLACE: wire to existing estimator (no new math)
final dailyUsedKesProvider = StateProvider<double>(
  (_) => 0,
); // <-- REPLACE: wire to server/secure state

final capStatusProvider = Provider<CapStatus>((ref) {
  final txKes = ref.watch(txKesProvider);
  final dailyUsedKes = ref.watch(dailyUsedKesProvider);

  // Compute breaches WITHOUT doing any FX math here:
  // Only evaluate if txKes is available; if not, we can still evaluate daily cap from dailyUsedKes.
  final nowDailyTotal = dailyUsedKes + (txKes ?? 0);
  final perTxnBreach = (txKes != null) && (txKes > MpesaCaps.perTxnKes);
  final dailyBreach = nowDailyTotal > MpesaCaps.dailyKes;

  if (!perTxnBreach && !dailyBreach) return CapStatus.none;

  final resetAt = nextMidnightNairobiUtc();
  final hints = buildResetHints(resetAt);

  if (perTxnBreach) {
    return CapStatus(
      breach: CapBreach.perTxn,
      inlineTitle: 'M-Pesa limit reached',
      inlineBody:
          'The amount exceeds the M-Pesa limit of KES 250,000 per transaction. Reduce the amount or choose Card.',
    );
  }

  // daily breach
  return CapStatus(
    breach: CapBreach.daily,
    inlineTitle: 'Daily M-Pesa limit reached',
    inlineBody:
        'You\'ve hit today\'s M-Pesa limit of KES 500,000. Try again after reset or choose Card. ${hints.shortHint}',
    resetShort: hints.shortHint,
    resetLongRel: hints.longRel,
    resetLongAbs: hints.longAbs,
  );
});
