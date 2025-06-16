import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> testSupabase() async {
  await Supabase.instance.client
      .from('restaurants')
      .select()
      .then((_) {}) // updated from deprecated .execute()
      ;

  // print(response.data); // [removed for production]
}
