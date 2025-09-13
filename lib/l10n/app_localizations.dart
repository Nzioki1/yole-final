import 'package:flutter/material.dart';

/// Simple localization utility for the app
///
/// This provides access to localized strings from the ARB files
class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // M-Pesa error messages
  String get mpesaPerTxnTitle => _getString('errors.mpesa.per_txn.title');
  String get mpesaPerTxnBody => _getString('errors.mpesa.per_txn.body');
  String get mpesaDailyTitle => _getString('errors.mpesa.daily.title');
  String get mpesaDailyBody => _getString('errors.mpesa.daily.body');

  // M-Pesa limits screen - per transaction
  String get mpesaPerTxnHeader => _getString('limits.mpesa.per_txn.header');
  String get mpesaPerTxnLead => _getString('limits.mpesa.per_txn.lead');
  String get mpesaPerTxnPoint1 => _getString('limits.mpesa.per_txn.point1');
  String get mpesaPerTxnPoint2 => _getString('limits.mpesa.per_txn.point2');
  String get mpesaPerTxnCtaPrimary =>
      _getString('limits.mpesa.per_txn.cta.primary');
  String get mpesaPerTxnCtaSecondary =>
      _getString('limits.mpesa.per_txn.cta.secondary');

  // M-Pesa limits screen - daily
  String get mpesaDailyHeader => _getString('limits.mpesa.daily.header');
  String get mpesaDailyLead => _getString('limits.mpesa.daily.lead');
  String get mpesaDailyPoint1 => _getString('limits.mpesa.daily.point1');
  String get mpesaDailyPoint2 => _getString('limits.mpesa.daily.point2');
  String get mpesaDailyPoint3 => _getString('limits.mpesa.daily.point3');
  String get mpesaDailyCtaPrimary =>
      _getString('limits.mpesa.daily.cta.primary');
  String get mpesaDailyCtaSecondary =>
      _getString('limits.mpesa.daily.cta.secondary');

  // Reset countdown messages
  String get limitsResetInline => _getString('limits.reset.inline');
  String get limitsResetRelative => _getString('limits.reset.relative');
  String get limitsResetAbsolute => _getString('limits.reset.absolute');

  // Common
  String get learnMore => _getString('common.learnMore');

  // Helper methods for parameterized strings
  String mpesaDailyBodyWithHint(String resetHint) {
    return mpesaDailyBody.replaceAll('{reset_hint}', resetHint);
  }

  String mpesaDailyPoint2WithHint(String resetHint) {
    return mpesaDailyPoint2.replaceAll('{reset_hint}', resetHint);
  }

  String limitsResetInlineWithTime(String timeShort) {
    return limitsResetInline.replaceAll('{time_short}', timeShort);
  }

  String limitsResetRelativeWithTime(String timeFull) {
    return limitsResetRelative.replaceAll('{time_full}', timeFull);
  }

  String limitsResetAbsoluteWithTime(String timeAbs) {
    return limitsResetAbsolute.replaceAll('{time_abs}', timeAbs);
  }

  String _getString(String key) {
    // For now, return the English strings directly
    // In a full implementation, this would load from the appropriate ARB file
    return _strings[key] ?? key;
  }

  static const Map<String, String> _strings = {
    'errors.mpesa.per_txn.title': 'M-Pesa limit reached',
    'errors.mpesa.per_txn.body':
        'The amount exceeds the M-Pesa limit of KES 250,000 per transaction. Reduce the amount or choose Card.',
    'errors.mpesa.daily.title': 'Daily M-Pesa limit reached',
    'errors.mpesa.daily.body':
        'You\'ve hit today\'s M-Pesa limit of KES 500,000. Try again after reset or choose Card. {reset_hint}',
    'limits.mpesa.per_txn.header': 'M-Pesa per-transaction limit',
    'limits.mpesa.per_txn.lead':
        'You\'ve reached the maximum amount allowed for a single M-Pesa transaction.',
    'limits.mpesa.per_txn.point1': 'Maximum per transaction: KES 250,000',
    'limits.mpesa.per_txn.point2':
        'To continue: reduce the amount below the limit or choose Card',
    'limits.mpesa.per_txn.cta.primary': 'Adjust amount',
    'limits.mpesa.per_txn.cta.secondary': 'Use Card instead',
    'limits.mpesa.daily.header': 'Daily M-Pesa limit',
    'limits.mpesa.daily.lead': 'You\'ve reached your daily M-Pesa limit.',
    'limits.mpesa.daily.point1': 'Daily total allowed: KES 500,000',
    'limits.mpesa.daily.point2': '{reset_hint}',
    'limits.mpesa.daily.point3': 'To continue now: use Card',
    'limits.mpesa.daily.cta.primary': 'Use Card instead',
    'limits.mpesa.daily.cta.secondary': 'Back to amount',
    'limits.reset.inline': 'Resets in {time_short}',
    'limits.reset.relative': 'Resets in {time_full}',
    'limits.reset.absolute': 'Next available at {time_abs} EAT',
    'common.learnMore': 'Learn more',
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
