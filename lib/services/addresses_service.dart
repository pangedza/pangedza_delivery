import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/address_model.dart';

class AddressesService {
  final _client = Supabase.instance.client;

  Future<List<AddressModel>> getAddresses(String userId) async {
    final res = await _client
        .from('addresses')
        .select()
        .eq('user_id', userId)
        .order('created_at');
    return List<Map<String, dynamic>>.from(res)
        .map(AddressModel.fromMap)
        .toList();
  }

  Future<AddressModel> add(AddressModel address, String userId) async {
    final data = address.toMap()
      ..remove('id')
      ..['user_id'] = userId;
    final inserted = await _client
        .from('addresses')
        .insert(data)
        .select()
        .single();
    return AddressModel.fromMap(inserted);
  }

  Future<void> update(AddressModel address) async {
    final data = address.toMap()..remove('id');
    await _client.from('addresses').update(data).eq('id', address.id);
  }

  Future<void> delete(String id) async {
    await _client.from('addresses').delete().eq('id', id);
  }
}
