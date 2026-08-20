// Entry point for the $l flavor build.
//
// Usage:
//   flutter build apk --flavor ar --target lib/main_ar.dart --dart-define=APP_FLAVOR=ar
//
// The actual bootstrap lives in main.dart; this file exists so each
// language flavor has a distinct Dart entry point recognised by Flutter.
import 'main.dart' as bootstrap;

void main() => bootstrap.main();