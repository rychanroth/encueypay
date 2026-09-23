import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The only supplier of [SupabaseClient] (CORE-03). Consumed exclusively by
/// repository implementations (DATA-04) — no table access happens anywhere
/// else (DATA-08).
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
