import 'package:supabase_flutter/supabase_flutter.dart';

class UsersService {
  final supabase = Supabase.instance.client;

  Future<String?> registerUser({required String name, required String phone, required String pin}) async {
    final normalizedPhone = phone.replaceAll(RegExp(r'[^+0-9]'), '');
    final existing = await supabase.from('users').select().eq('phone', normalizedPhone).maybeSingle();
    if (existing != null) return null;

    final response = await supabase.from('users').insert({
      'name': name,
      'phone': normalizedPhone,
      'pin_code': pin,
    }).select().single();

    return response['id'];
  }

  Future<String?> loginUser({required String phone, required String pin}) async {
    final normalizedPhone = phone.replaceAll(RegExp(r'[^+0-9]'), '');
    final user = await supabase
        .from('users')
        .select()
        .eq('phone', normalizedPhone)
        .eq('pin_code', pin)
        .maybeSingle();
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

