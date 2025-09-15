import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yole_final/features/send/screens/send_recipient_screen.dart';

/// Test router configuration for recipient screen tests
///
/// This router starts at the recipient screen for testing
final RouterConfig<Object> recipientTestRouter = GoRouter(
  initialLocation: '/send/recipient',
  routes: [
    GoRoute(
      path: '/send/recipient',
      builder: (context, state) => const SendRecipientScreen(),
    ),
    GoRoute(
      path: '/send/network',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Network Screen'))),
    ),
  ],
  // No redirects or guards for tests
  redirect: (context, state) => null,
);
