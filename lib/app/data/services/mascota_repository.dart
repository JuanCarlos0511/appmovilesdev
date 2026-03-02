import '../model/mascota_model.dart';
import '../provider/mascota_provider.dart';

/// Repositorio de mascotas: abstrae la fuente de datos
/// del resto de la aplicación (controllers, otros servicios).
class MascotaRepository {
  final MascotaProvider _provider;

  MascotaRepository(this._provider);

  Future<List<Mascota>> getAll() => _provider.getAll();

  Future<Mascota> add(Mascota mascota) => _provider.add(mascota);

  Future<Mascota> update(Mascota mascota) => _provider.update(mascota);

  Future<void> delete(String id) => _provider.delete(id);
}
