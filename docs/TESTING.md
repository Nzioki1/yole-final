# Testing Guide - Yole Flutter App
**Date:** 2025-01-27  
**Test Infrastructure Engineer:** AI Test Infrastructure Engineer  
**Project:** Yole MVP Flutter App  

## Executive Summary

This document provides comprehensive testing guidelines for the Yole Flutter application, including unit tests, widget tests, integration tests, and golden tests. All visual changes must include updated golden tests.

**Enforcement:** All PRs with visual changes must include updated golden tests. No exceptions.

---

## 🧪 **TESTING COMMANDS**

### **Run All Tests**
```bash
flutter test
```

### **Run Only Golden Tests**
```bash
flutter test test/goldens
```

### **Update Golden Test Baselines**
```bash
flutter test --update-goldens test/goldens
```

### **Run Specific Test Categories**
```bash
# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests only
flutter test integration_test/

# Golden tests only
flutter test test/goldens/
```

### **Run Tests with Coverage**
```bash
flutter test --coverage
```

### **Run Tests in Headless Mode (CI)**
```bash
# For CI environments
flutter test --reporter=json
```

---

## 🎨 **GOLDEN TESTING**

### **What are Golden Tests?**
Golden tests capture screenshots of widgets and compare them against baseline images to detect visual regressions. They ensure UI consistency across changes.

### **Golden Test Structure**
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
└── README.md                       # Golden test documentation
```

### **Device Configurations**
Golden tests run on multiple device configurations:
- **Small:** 360x690 @ DPR 2.0
- **Medium:** 390x844 @ DPR 3.0  
- **Large:** 412x915 @ DPR 2.625

### **Theme Variants**
All golden tests capture both light and dark theme variants:
- `component_name_light.png`
- `component_name_dark.png`

### **Creating Golden Tests**

#### **1. Component Golden Test**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import '../_harness/golden_config.dart';

void main() {
  group('ComponentName Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('ComponentName - Standard', (tester) async {
      final widget = _buildComponent();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/component_name',
      );
    });
  });
}
```

#### **2. Screen Golden Test**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import '../_harness/golden_config.dart';

void main() {
  group('ScreenName Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('ScreenName - Standard', (tester) async {
      final widget = _buildScreen();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/screen_name',
      );
    });
  });
}
```

### **Golden Test Best Practices**

#### **✅ Do's**
- Use mock data for consistent results
- Test both light and dark themes
- Test multiple device sizes
- Use descriptive test names
- Group related tests together
- Keep test data realistic

#### **❌ Don'ts**
- Don't use real API data
- Don't skip theme variants
- Don't use hardcoded values
- Don't create overly complex test scenarios
- Don't ignore golden test failures

---

## 🔧 **TEST CONFIGURATION**

### **Golden Test Harness**
The golden test harness (`test/goldens/_harness/golden_config.dart`) provides:
- Device configurations
- Theme setup
- Helper functions
- Mock data
- Material app wrapper

### **Font Loading**
Golden tests load Inter font for consistent rendering:
```dart
await loadAppFontsFromGoogleFonts(
  fontFamily: 'Inter',
  fallbackFontFamily: 'Roboto',
);
```

### **Theme Integration**
Golden tests use the project's theme system:
```dart
static Widget materialAppWrapper({
  required Widget child,
  required Brightness brightness,
}) {
  return MaterialApp(
    theme: brightness == Brightness.light ? YoleTheme.light : YoleTheme.dark,
    home: Scaffold(body: child),
  );
}
```

---

## 📋 **TESTING REQUIREMENTS**

### **Unit Tests**
- **Coverage:** Minimum 80% for new code
- **Scope:** Business logic, utilities, data models
- **Naming:** `should_<expected_behavior>_when_<condition>`

### **Widget Tests**
- **Coverage:** All new widgets must have tests
- **Scope:** Widget behavior, user interactions
- **Mocking:** Use mock data and providers

### **Integration Tests**
- **Coverage:** Critical user journeys
- **Scope:** End-to-end workflows
- **Data:** Use test data, not production APIs

### **Golden Tests**
- **Coverage:** All visual components and screens
- **Scope:** UI consistency, theme variants
- **Updates:** Required for any visual changes

---

## 🚨 **GOLDEN TEST GUARDRAILS**

### **Design Token Enforcement**
- **No hardcoded colors** in lib/** except theme files
- **No hardcoded text styles** in components
- **No hardcoded spacing** in widgets
- **Use design tokens** from theme system

### **Lint Rules**
```yaml
# analysis_options.yaml
rules:
  avoid_redundant_raw_strings: true
  prefer_const_constructors: true
  prefer_const_literals_to_create_immutables: true
  prefer_const_constructors_in_immutables: true
```

### **CI Enforcement**
```bash
# Check for hardcoded values
grep -r "Color(0x" lib/ --include="*.dart" | grep -v "theme"
grep -r "TextStyle(" lib/ --include="*.dart" | grep -v "theme"
grep -r "EdgeInsets.all(" lib/ --include="*.dart" | grep -v "theme"
```

---

## 🔄 **CI/CD INTEGRATION**

### **GitHub Actions Workflow**
```yaml
# .github/workflows/flutter-ci.yml
- name: Golden tests
  run: flutter test test/goldens

- name: Check for hardcoded values
  run: |
    if grep -r "Color(0x" lib/ --include="*.dart" | grep -v "theme"; then
      echo "Hardcoded colors detected. Use design tokens."
      exit 1
    fi
```

### **Golden Test Approval Process**
1. **Visual Change Made** - Developer updates UI
2. **Golden Tests Fail** - CI detects visual differences
3. **Review Changes** - Team reviews visual changes
4. **Approve Update** - Maintainer runs `--update-goldens`
5. **Commit Baselines** - Updated golden files committed

---

## 📊 **TEST COVERAGE**

### **Coverage Targets**
- **Unit Tests:** ≥ 80%
- **Widget Tests:** 100% of new widgets
- **Integration Tests:** Critical user journeys
- **Golden Tests:** All visual components

### **Coverage Reporting**
```bash
# Generate coverage report
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🐛 **TROUBLESHOOTING**

### **Common Golden Test Issues**

#### **1. Font Loading Errors**
```
Error: Font family 'Inter' not found
```
**Solution:**
- Ensure fonts are properly declared in pubspec.yaml
- Check font file paths are correct
- Verify loadAppFonts() is called in setUpAll

#### **2. Theme Not Applied**
```
Error: Widget doesn't match expected theme
```
**Solution:**
- Use GoldenConfig.materialAppWrapper
- Ensure theme is properly imported
- Check brightness parameter

#### **3. Device Size Mismatch**
```
Error: Widget size doesn't match device configuration
```
**Solution:**
- Use correct device configuration
- Check surfaceSize parameter
- Verify devicePixelRatio

### **Debug Commands**
```bash
# Run specific golden test
flutter test test/goldens/components/amount_display_golden_test.dart

# Update specific golden test
flutter test --update-goldens test/goldens/components/amount_display_golden_test.dart

# Run with verbose output
flutter test --verbose test/goldens/
```

---

## 📝 **TESTING CHECKLIST**

### **Before Committing**
- [ ] All tests pass (`flutter test`)
- [ ] Golden tests pass (`flutter test test/goldens`)
- [ ] No hardcoded values in lib/**
- [ ] Design tokens used properly
- [ ] Test coverage meets requirements
- [ ] Mock data used for tests

### **For Visual Changes**
- [ ] Golden tests updated (`--update-goldens`)
- [ ] Both light and dark themes tested
- [ ] Multiple device sizes tested
- [ ] Visual changes reviewed by team
- [ ] Golden baselines committed

### **For New Features**
- [ ] Unit tests written
- [ ] Widget tests written
- [ ] Integration tests written
- [ ] Golden tests written
- [ ] Test coverage meets targets
- [ ] Documentation updated

---

## 📚 **REFERENCE DOCUMENTS**

- **Golden Toolkit Documentation** - [pub.dev](https://pub.dev/packages/golden_toolkit)
- **Flutter Testing Guide** - [Flutter Docs](https://docs.flutter.dev/testing)
- **Widget Testing** - [Flutter Docs](https://docs.flutter.dev/cookbook/testing/widget)
- **Integration Testing** - [Flutter Docs](https://docs.flutter.dev/testing/integration-tests)

---

## 📞 **SUPPORT CONTACTS**

**Test Infrastructure Team:** testing@yole.com  
**QA Team:** qa@yole.com  
**DevOps Team:** devops@yole.com  

**Emergency Contact:** +1-XXX-XXX-XXXX (24/7)

---

**Document Status:** ACTIVE  
**Last Updated:** 2025-01-27  
**Next Review:** 2025-04-27

