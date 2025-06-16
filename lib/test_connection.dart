import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> testSupabase() async {
  final response = await Supabase.instance.client
      .from('restaurants')
      .select()
      .execute();

  print(response.data);
}
