import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';
import '../models/profile_model.dart';
import 'profile_edit_screen.dart';
import 'addresses_screen.dart';
import 'welcome_screen.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profile = ProfileModel.instance;

  @override
  void initState() {
    super.initState();
    profile.load();
  }

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime? date) {
      if (date == null) return '';
      return DateFormat('dd/MM/yyyy', 'ru').format(date);
    }

    return Scaffold(
      drawer: const MyAppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: profile,
        builder: (_, __) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                leading: const Icon(Icons.perm_identity, color: Colors.red),
                title: const Text(
                  'ID пользователя',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: Text(profile.id),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Телефон'),
                subtitle: Text(context.watch<ProfileModel>().phone),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Имя'),
                subtitle: Text(context.watch<ProfileModel>().name),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Дата рождения'),
                subtitle: Text(formatDate(profile.birthDate)),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.transgender),
                title: const Text('Пол'),
                subtitle: Text(profile.gender),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Адреса'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddressesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.redButton,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text('Выйти'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
