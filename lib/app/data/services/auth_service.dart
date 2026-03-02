import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/values/supabase_config.dart';
import '../../routes/routes.dart';

/// Servicio de autenticación (Supabase Auth).
/// Se registra como [GetxService] para que persista en toda la app.
class AuthService extends GetxService {
  final SupabaseClient _client = Supabase.instance.client;

  final _googleSignIn = GoogleSignIn(
    serverClientId: SupabaseConfig.googleWebClientId,
  );

  /// Usuario reactivo — se actualiza con cada cambio de sesión.
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _client.auth.currentUser;
    _client.auth.onAuthStateChange.listen((data) {
      currentUser.value = data.session?.user;
    });
  }

  bool get isLoggedIn => currentUser.value != null;

  // ---------- Email / Password ----------

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _client.auth.signUp(email: email, password: password);
  }

  // ---------- Google OAuth ----------

  /// Inicia sesión con Google. Si el usuario no existe en Supabase,
  /// se registra automáticamente (upsert nativo de Supabase Auth).
  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelado.');

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) throw Exception('No se pudo obtener el ID token de Google.');

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // ---------- Sign Out ----------

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _client.auth.signOut();
    Get.offAllNamed(Routes.login);
  }
}
