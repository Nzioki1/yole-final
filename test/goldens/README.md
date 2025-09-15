# Golden Tests Directory

This directory contains golden tests for visual regression testing of the Yole Flutter app.

## Structure

```
test/goldens/
├── _harness/
│   └── golden_config.dart          # Configuration and utilities
├── components/
│   ├── amount_display_golden_test.dart
│   ├── status_chip_golden_test.dart
│   └── gradient_button_golden_test.dart
├── screens/
│   ├── send_review_golden_test.dart
│   ├── home_screen_golden_test.dart
│   └── profile_screen_golden_test.dart
└── README.md                       # This file
```

## Running Golden Tests

### Run All Golden Tests
```bash
flutter test test/goldens
```

### Update Golden Baselines
```bash
flutter test --update-goldens test/goldens
```

### Run Specific Golden Test
```bash
flutter test test/goldens/components/amount_display_golden_test.dart
```

## Golden Test Files

Golden test files are automatically generated in the `test/goldens/` directory with the following naming convention:

- `component_name_light.png` - Light theme variant
- `component_name_dark.png` - Dark theme variant
- `component_name_small_light.png` - Small device, light theme
- `component_name_medium_dark.png` - Medium device, dark theme
- `component_name_large_light.png` - Large device, light theme

## Device Configurations

Golden tests run on three device configurations:

- **Small:** 360x690 @ DPR 2.0
- **Medium:** 390x844 @ DPR 3.0
- **Large:** 412x915 @ DPR 2.625

## Theme Variants

All golden tests capture both light and dark theme variants to ensure proper theming.

## Adding New Golden Tests

1. Create a new test file in the appropriate directory (`components/` or `screens/`)
2. Import the golden test harness: `import '../_harness/golden_config.dart';`
3. Use `GoldenConfig.pumpMultiGolden()` for light/dark variants
4. Use `GoldenConfig.pumpComprehensiveGolden()` for all devices and themes
5. Run tests and commit the generated PNG files

## Best Practices

- Use mock data for consistent results
- Test both light and dark themes
- Test multiple device sizes for responsive design
- Use descriptive test names
- Keep test scenarios realistic
- Don't use real API data in tests

## Troubleshooting

### Font Issues
If you see font-related errors, ensure:
- Inter font files are in `assets/fonts/Inter/`
- Fonts are declared in `pubspec.yaml`
- `loadAppFonts()` is called in `setUpAll`

### Theme Issues
If themes aren't applied correctly:
- Use `GoldenConfig.materialAppWrapper`
- Ensure theme imports are correct
- Check brightness parameter

### Device Size Issues
If device sizes don't match:
- Use correct device configuration
- Check `surfaceSize` parameter
- Verify `devicePixelRatio`

## CI Integration

Golden tests are automatically run in CI/CD pipeline:
- Tests must pass for PR approval
- Visual changes require golden test updates
- Hardcoded values are detected and blocked

## Maintenance

- Review golden test failures carefully
- Update baselines only for intentional visual changes
- Keep test data up-to-date with app changes
- Remove obsolete golden tests when components are removed

