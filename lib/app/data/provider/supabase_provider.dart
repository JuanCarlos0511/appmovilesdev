import 'package:supabase_flutter/supabase_flutter.dart';

/// Wrapper ligero que expone el [SupabaseClient] singleton.
/// Inyectado via GetX en los providers que lo necesitan.
class SupabaseProvider {
  SupabaseClient get client => Supabase.instance.client;
}
