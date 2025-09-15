import 'package:flutter/foundation.dart';

abstract class Analytics {
  Future<void> logEvent(String name, Map<String, Object?> params);
}

class FakeAnalytics implements Analytics {
  final List<String> calls = [];
  @override
  Future<void> logEvent(String name, Map<String, Object?> params) async {
    calls.add('$name:${params.keys.join(",")}');
  }
}

abstract class Crash {
  void recordError(Object e, StackTrace st);
}

class FakeCrash implements Crash {
  final List<Object> errors = [];
  @override
  void recordError(Object e, StackTrace st) {
    errors.add(e);
    debugPrint('CRASH:$e');
  }
}

