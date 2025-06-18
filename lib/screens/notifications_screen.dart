import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/info_service.dart';
import '../models/app_notification.dart';
import '../widgets/app_drawer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _service = InfoService();
  List<AppNotification> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await _service.fetchNotifications();
    if (mounted) {
      setState(() {
        _items = list;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyAppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Уведомления'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('Нет уведомлений'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length,
                  itemBuilder: (_, index) {
                    final n = _items[index];
                    final date = DateFormat('dd.MM.yyyy').format(n.createdAt);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text(n.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(date, style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(n.text),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
