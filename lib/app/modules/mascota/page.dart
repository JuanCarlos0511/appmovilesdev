import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import '../../data/model/mascota_model.dart';

class MascotaPage extends GetView<MascotaController> {
  const MascotaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Mascotas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: controller.signOut,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.mascotas.length,
          itemBuilder: (context, index) {
            final mascota = controller.mascotas[index];
            return ListTile(
              title: Text(mascota.nombre),
              subtitle: Text('${mascota.especie} - ${mascota.edad} años'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.deleteMascota(mascota.id),
              ),
              onTap: () => _showEditDialog(context, mascota),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(context),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final speciesController = TextEditingController();
    final ageController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Añadir Mascota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: speciesController,
              decoration: const InputDecoration(labelText: 'Especie'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.addMascota(
                nameController.text,
                speciesController.text,
                int.tryParse(ageController.text) ?? 0,
              );
              Get.back();
            },
            child: const Text('Añadir'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Mascota mascota) {
    final nameController = TextEditingController(text: mascota.nombre);
    final speciesController = TextEditingController(text: mascota.especie);
    final ageController = TextEditingController(text: mascota.edad.toString());

    Get.dialog(
      AlertDialog(
        title: const Text('Editar Mascota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: speciesController,
              decoration: const InputDecoration(labelText: 'Especie'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final updated = mascota.copyWith(
                nombre: nameController.text.trim(),
                especie: speciesController.text.trim(),
                edad: int.tryParse(ageController.text) ?? mascota.edad,
              );
              controller.updateMascota(updated);
              Get.back();
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }
}
