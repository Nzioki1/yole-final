import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/ui/components/amount_display.dart';
import 'package:yole_final/core/money.dart';
import '../_harness/golden_config.dart';

/// Golden tests for AmountDisplay component
///
/// Tests various amount display scenarios including:
/// - Different currencies (USD, EUR, KES)
/// - Different variants (primary, secondary)
/// - With and without exchange rate information
/// - Both light and dark theme variants
void main() {
  group('AmountDisplay Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('AmountDisplay - USD Primary', (tester) async {
      final widget = _buildAmountDisplay(
        money: Money.fromMajor(12.34, 'USD'),
        variant: 'primary',
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/amount_display_usd_primary',
      );
    });

    testGoldens('AmountDisplay - EUR Primary', (tester) async {
      final widget = _buildAmountDisplay(
        money: Money.fromMajor(500.00, 'EUR'),
        variant: 'primary',
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/amount_display_eur_primary',
      );
    });

    testGoldens('AmountDisplay - KES Primary', (tester) async {
      final widget = _buildAmountDisplay(
        money: Money.fromMajor(25000.00, 'KES'),
        variant: 'primary',
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/amount_display_kes_primary',
      );
    });

    testGoldens('AmountDisplay - Secondary Variant', (tester) async {
      final widget = _buildAmountDisplay(
        money: Money.fromMajor(150.75, 'USD'),
        variant: 'secondary',
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/amount_display_secondary',
      );
    });

    testGoldens('AmountDisplay - With Exchange Rate', (tester) async {
      final widget = _buildAmountDisplay(
        money: Money.fromMajor(100.00, 'USD'),
        variant: 'primary',
        showApproxFx: true,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/amount_display_with_fx',
      );
    });

    testGoldens('AmountDisplay - Zero Amount', (tester) async {
      final widget = _buildAmountDisplay(
        money: Money.fromMajor(0.00, 'USD'),
        variant: 'primary',
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/amount_display_zero',
      );
    });

    testGoldens('AmountDisplay - Large Amount', (tester) async {
      final widget = _buildAmountDisplay(
        money: Money.fromMajor(9999.99, 'USD'),
        variant: 'primary',
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/amount_display_large',
      );
    });

    testGoldens('AmountDisplay - Comparison', (tester) async {
      final widget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAmountDisplay(
            money: Money.fromMajor(1234.56, 'USD'),
            variant: 'primary',
          ),
          const SizedBox(height: 16),
          _buildAmountDisplay(
            money: Money.fromMajor(1234.56, 'USD'),
            variant: 'secondary',
          ),
          const SizedBox(height: 16),
          _buildAmountDisplay(
            money: Money.fromMajor(1234.56, 'USD'),
            variant: 'primary',
            showApproxFx: true,
          ),
        ],
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/amount_display_comparison',
      );
    });
  });
}

/// Build AmountDisplay widget for testing
Widget _buildAmountDisplay({
  required Money money,
  String variant = 'primary',
  bool showApproxFx = false,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: AmountDisplay(
      money: money,
      variant: variant,
      showApproxFx: showApproxFx,
    ),
  );
}
