import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/about_info.dart';
import '../models/app_notification.dart';

class InfoService {
  final _client = Supabase.instance.client;

  Future<AboutInfo?> fetchAbout() async {
    final data = await _client.from('about_info').select().limit(1).maybeSingle();
    if (data == null) return null;
    return AboutInfo.fromMap(data);
  }

  Future<List<AppNotification>> fetchNotifications() async {
    final res = await _client
        .from('notifications')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res)
        .map(AppNotification.fromMap)
        .toList();
  }
}
