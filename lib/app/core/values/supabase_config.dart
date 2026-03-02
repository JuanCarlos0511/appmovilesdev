/// Credenciales de Supabase.
///
/// Los valores se inyectan en tiempo de compilación desde `.env.json`
/// usando `--dart-define-from-file` (configurado en `.vscode/launch.json`).
///
/// Para ejecutar desde terminal:
///   flutter run --dart-define-from-file=.env.json
///
/// Edita `.env.json` con tus claves reales (nunca lo subas a git).
class SupabaseConfig {
  SupabaseConfig._();

  /// Project URL  →  Settings → API → Project URL
  static const String url = String.fromEnvironment('SUPABASE_URL');

  /// anon / public key  →  Settings → API → Project API keys
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Web Client ID de Google Cloud Console
  /// (el de tipo "Web application", NO el de Android)
  static const String googleWebClientId =
      String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
}
