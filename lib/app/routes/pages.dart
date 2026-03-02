import 'package:get/get.dart';
import 'routes.dart';
import '../modules/my_module/page.dart';
import '../modules/my_module/binding.dart';
import '../modules/login/page.dart';
import '../modules/login/binding.dart';
import '../modules/mascota/page.dart';
import '../modules/mascota/binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => MyModulePage(),
      binding: MyModuleBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.mascota,
      page: () => const MascotaPage(),
      binding: MascotaBinding(),
    ),
  ];
}
