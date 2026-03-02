import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes/routes.dart';

/// Servicio de autenticación (Supabase Auth).
/// Se registra como [GetxService] para que persista en toda la app.
class AuthService extends GetxService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Usuario reactivo — se actualiza con cada cambio de sesión.
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Estado inicial
    currentUser.value = _client.auth.currentUser;

    // Escucha cambios de sesión (sign-in, sign-out, token refresh)
    _client.auth.onAuthStateChange.listen((data) {
      currentUser.value = data.session?.user;
    });
  }

  bool get isLoggedIn => currentUser.value != null;

  // ---------- Operaciones ----------

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

  Future<void> signOut() async {
    await _client.auth.signOut();
    Get.offAllNamed(Routes.login);
  }
}
