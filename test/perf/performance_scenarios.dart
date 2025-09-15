/// Performance test scenarios for measuring widget build times
///
/// Defines various widget builders for performance testing scenarios
/// including screens, components, and complex UI patterns.
library;

import 'package:flutter/material.dart';
import 'package:yole_final/features/send/screens/send_amount_screen.dart';
import 'package:yole_final/features/send/screens/send_review_screen.dart';
import 'package:yole_final/features/onboarding/welcome_screen.dart';
import 'package:yole_final/features/send/screens/send_network_screen.dart';
import 'package:yole_final/ui/components/loading_states.dart';
import 'package:yole_final/ui/effects/sparkle_layer.dart';
import 'package:yole_final/core/money.dart';
import 'package:yole_final/features/send/state/send_state.dart';

/// Performance test scenarios
class PerformanceScenarios {
  /// Send amount screen with skeleton loading (static)
  static WidgetBuilder sendAmountScreen = (context) {
    return const SendAmountScreen();
  };

  /// Send review screen with transaction details
  static WidgetBuilder sendReviewScreen = (context) {
      // Simplified SendReviewScreen for performance testing
      return const SendReviewScreen();
  };

  /// Welcome screen with SparkleLayer (static frame)
  static WidgetBuilder welcomeScreen = (context) {
    return const WelcomeScreen();
  };

  /// Network selection screen
  static WidgetBuilder networkSelectionScreen = (context) {
    return const SendNetworkScreen();
  };

  /// Recipient selection screen
  static WidgetBuilder recipientSelectionScreen = (context) {
    return const SendAmountScreen(); // Simplified for testing
  };

  /// Skeleton loading states (static)
  static WidgetBuilder skeletonLoading = (context) {
    return LoadingStates(
      type: SkeletonType.list,
      itemCount: 6,
      animate: false, // Static for performance testing
    );
  };

  /// Complex form with multiple inputs
  static WidgetBuilder complexForm = (context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complex Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(10, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Field ${index + 1}',
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          }),
        ),
      ),
    );
  };

  /// List with many items
  static WidgetBuilder longList = (context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Long List')),
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text('Item ${index + 1}'),
            subtitle: Text('Subtitle for item ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  };

  /// Grid with many items
  static WidgetBuilder gridView = (context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid View')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: 50,
        itemBuilder: (context, index) {
          return Card(
            child: Center(
              child: Text('Item ${index + 1}'),
            ),
          );
        },
      ),
    );
  };

  /// Animation-heavy widget
  static WidgetBuilder animatedWidget = (context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Widget')),
      body: const Center(
        child: SparkleLayer(
          quality: SparkleQuality.medium,
          staticFrame: Duration(milliseconds: 300), // Static for performance
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, size: 64),
              SizedBox(height: 16),
              Text('Animated Content'),
            ],
          ),
        ),
      ),
    );
  };

  /// Heavy computation widget
  static WidgetBuilder heavyComputation = (context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heavy Computation')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing...'),
          ],
        ),
      ),
    );
  };

  /// All available scenarios for testing
  static Map<String, WidgetBuilder> getAllScenarios() {
    return {
      'sendAmountScreen': sendAmountScreen,
      'sendReviewScreen': sendReviewScreen,
      'welcomeScreen': welcomeScreen,
      'networkSelectionScreen': networkSelectionScreen,
      'recipientSelectionScreen': recipientSelectionScreen,
      'skeletonLoading': skeletonLoading,
      'complexForm': complexForm,
      'longList': longList,
      'gridView': gridView,
      'animatedWidget': animatedWidget,
      'heavyComputation': heavyComputation,
    };
  }

  /// Core scenarios that should meet performance budget
  static Map<String, WidgetBuilder> getCoreScenarios() {
    return {
      'sendAmountScreen': sendAmountScreen,
      'sendReviewScreen': sendReviewScreen,
      'welcomeScreen': welcomeScreen,
    };
  }

  /// Extended scenarios for comprehensive testing
  static Map<String, WidgetBuilder> getExtendedScenarios() {
    return {
      'networkSelectionScreen': networkSelectionScreen,
      'recipientSelectionScreen': recipientSelectionScreen,
      'skeletonLoading': skeletonLoading,
    };
  }

  /// Stress test scenarios
  static Map<String, WidgetBuilder> getStressTestScenarios() {
    return {
      'complexForm': complexForm,
      'longList': longList,
      'gridView': gridView,
      'animatedWidget': animatedWidget,
      'heavyComputation': heavyComputation,
    };
  }
}