import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---------- Ícono ----------
                const Icon(Icons.pets, size: 72, color: Colors.deepPurple),
                const SizedBox(height: 16),

                // ---------- Título reactivo ----------
                Obx(() => Text(
                      controller.isLoginMode.value ? 'Iniciar sesión' : 'Registrarse',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    )),
                const SizedBox(height: 32),

                // ---------- Email ----------
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'correo@ejemplo.com',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- Contraseña ----------
                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // ---------- Botón principal ----------
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.submit(
                                  emailCtrl.text,
                                  passwordCtrl.text,
                                ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Obx(() => Text(
                                  controller.isLoginMode.value
                                      ? 'Entrar'
                                      : 'Crear cuenta',
                                )),
                      ),
                    )),
                const SizedBox(height: 12),

                // ---------- Cambiar modo ----------
                Obx(() => TextButton(
                      onPressed: controller.toggleMode,
                      child: Text(
                        controller.isLoginMode.value
                            ? '¿No tienes cuenta? Regístrate'
                            : '¿Ya tienes cuenta? Inicia sesión',
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
