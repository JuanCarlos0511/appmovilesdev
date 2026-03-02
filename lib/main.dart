import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/core/theme/app_theme.dart';
import 'app/core/values/supabase_config.dart';
import 'app/data/services/auth_service.dart';
import 'app/routes/pages.dart';
import 'app/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validar que las variables de entorno fueron inyectadas.
  // Si están vacías la app se ejecutó sin --dart-define-from-file=.env.json
  assert(
    SupabaseConfig.url.isNotEmpty,
    '\n\n'
    '❌  SUPABASE_URL está vacío.\n'
    '   Ejecuta con: flutter run --dart-define-from-file=.env.json\n'
    '   O usa F5 en VS Code con la configuración "appmovilesdev (debug)".\n',
  );

  // Inicializar Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Registrar AuthService como singleton persistente
  Get.put<AuthService>(AuthService(), permanent: true);

  // Determinar ruta inicial en función de la sesión activa
  final initialRoute = Get.find<AuthService>().isLoggedIn
      ? Routes.mascota
      : Routes.login;

  runApp(
    GetMaterialApp(
      title: 'Mascotas App',
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      theme: appThemeData,
      debugShowCheckedModeBanner: false,
    ),
  );
}

