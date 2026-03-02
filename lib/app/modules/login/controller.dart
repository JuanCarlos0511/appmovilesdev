import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/services/auth_service.dart';
import '../../routes/routes.dart';

/// Controlador del módulo de Login / Registro.
class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  /// true = pantalla de Login | false = pantalla de Registro
  final RxBool isLoginMode = true.obs;

  // ---------- Email / Password ----------

  Future<void> submit(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      Get.snackbar(
        'Campos requeridos',
        'Por favor completa email y contraseña.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      if (isLoginMode.value) {
        await _authService.signIn(email: email.trim(), password: password);
      } else {
        await _authService.signUp(email: email.trim(), password: password);
      }
      Get.offAllNamed(Routes.mascota);
    } on AuthException catch (e) {
      Get.snackbar(
        'Error de autenticación',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (_) {
      Get.snackbar(
        'Error',
        'Ocurrió un error inesperado. Intenta de nuevo.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ---------- Google ----------

  Future<void> signInWithGoogle() async {
    isGoogleLoading.value = true;
    try {
      await _authService.signInWithGoogle();
      Get.offAllNamed(Routes.mascota);
    } on AuthException catch (e) {
      Get.snackbar(
        'Error de Google',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      final msg = e.toString();
      if (!msg.contains('cancelado')) {
        Get.snackbar(
          'Error de Google',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 6),
        );
      }
    } finally {
      isGoogleLoading.value = false;
    }
  }

  void toggleMode() => isLoginMode.toggle();
}
