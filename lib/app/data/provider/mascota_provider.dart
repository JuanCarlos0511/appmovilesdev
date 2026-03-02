import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/mascota_model.dart';
import 'supabase_provider.dart';

/// Provider de mascotas: accede directamente a la tabla `mascotas`
/// en Supabase. La seguridad por usuario la garantiza RLS en el servidor.
class MascotaProvider {
  final SupabaseProvider _supabaseProvider;

  MascotaProvider(this._supabaseProvider);

  static const String _table = 'mascotas';

  SupabaseClient get _client => _supabaseProvider.client;

  // ---------- CRUD ----------

  Future<List<Mascota>> getAll() async {
    final response = await _client.from(_table).select();
    return response.map((e) => Mascota.fromJson(e)).toList();
  }

  Future<Mascota> add(Mascota mascota) async {
    final userId = _client.auth.currentUser!.id;

    final payload = {
      'nombre': mascota.nombre,
      'especie': mascota.especie,
      'edad': mascota.edad,
      'user_id': userId,
    };

    final response =
        await _client.from(_table).insert(payload).select().single();
    return Mascota.fromJson(response);
  }

  Future<Mascota> update(Mascota mascota) async {
    final payload = {
      'nombre': mascota.nombre,
      'especie': mascota.especie,
      'edad': mascota.edad,
    };

    final response = await _client
        .from(_table)
        .update(payload)
        .eq('id', mascota.id)
        .select()
        .single();
    return Mascota.fromJson(response);
  }

  Future<void> delete(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
