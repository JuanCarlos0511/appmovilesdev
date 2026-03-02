import 'package:get/get.dart';
import '../../data/model/mascota_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/mascota_repository.dart';

class MascotaController extends GetxController {
  final MascotaRepository _repository;
  final AuthService _authService = Get.find<AuthService>();

  MascotaController(this._repository);

  final RxList<Mascota> mascotas = <Mascota>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMascotas();
  }

  Future<void> loadMascotas() async {
    isLoading.value = true;
    try {
      mascotas.assignAll(await _repository.getAll());
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar las mascotas.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Crea una nueva mascota; el ID lo asigna Supabase (UUID).
  Future<void> addMascota(String nombre, String especie, int edad) async {
    if (nombre.trim().isEmpty || especie.trim().isEmpty) return;
    final mascota = Mascota(
      id: '', // ignorado — Supabase genera UUID
      nombre: nombre.trim(),
      especie: especie.trim(),
      edad: edad,
    );
    try {
      final created = await _repository.add(mascota);
      mascotas.add(created);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo agregar la mascota.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateMascota(Mascota mascota) async {
    try {
      final updated = await _repository.update(mascota);
      final index = mascotas.indexWhere((m) => m.id == updated.id);
      if (index != -1) mascotas[index] = updated;
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la mascota.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteMascota(String id) async {
    try {
      await _repository.delete(id);
      mascotas.removeWhere((m) => m.id == id);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar la mascota.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signOut() => _authService.signOut();
}
