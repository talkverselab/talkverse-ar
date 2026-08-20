import 'package:supabase_flutter/supabase_flutter.dart';

import '../db/app_database.dart';

/// Holds shared singletons for Supabase client and the local Drift database.
/// Initialize once at app start, before any repository call.
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  late final AppDatabase db;

  SupabaseClient get client => Supabase.instance.client;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    db = AppDatabase();
    _initialized = true;
  }
}
