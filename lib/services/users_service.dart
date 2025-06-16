import 'package:supabase_flutter/supabase_flutter.dart';

class UsersService {
  final supabase = Supabase.instance.client;

  Future<String?> registerUser({required String name, required String phone, required String pin}) async {
    final existing = await supabase.from('users').select().eq('phone', phone).maybeSingle();
    if (existing != null) return null;

    final response = await supabase.from('users').insert({
      'name': name,
      'phone': phone,
      'pin_code': pin,
    }).select().single();

    return response['id'];
  }

  Future<String?> loginUser({required String phone, required String pin}) async {
    final user = await supabase.from('users').select().eq('phone', phone).eq('pin_code', pin).maybeSingle();
    return user?['id'];
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }
}

