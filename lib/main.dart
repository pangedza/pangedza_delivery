import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/profile_model.dart';
import 'screens/welcome_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/reviews/reviews_screen.dart';
import 'screens/game_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/about_screen.dart';
import 'screens/addresses_screen.dart';
import 'widgets/bottom_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Checking .env exists: ${File('.env').existsSync()}');
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    print('Ошибка загрузки .env: $e');
  }
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE30613),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFE30613),
          unselectedItemColor: Colors.black54,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFE30613),
          background: Colors.white,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru', '')],
      initialRoute: '/',
      routes: {
        '/': (_) => const WelcomeScreen(),
        '/main': (_) => const MainScreen(),
        '/profile': (_) => const MainScreen(initialIndex: 0),
        '/cart': (_) => const MainScreen(initialIndex: 2),
        '/history': (_) => const MainScreen(initialIndex: 3),
        '/reviews': (_) => const MainScreen(initialIndex: 4),
        '/notifications': (_) => const NotificationsScreen(),
        '/about': (_) => const AboutScreen(),
        '/addresses': (_) => const AddressesScreen(),
      },
    );
  }
}

/// Stateful widget that holds bottom navigation logic.
class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 1});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  final profile = ProfileModel.instance;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    profile.addListener(_profileChanged);
    profile.load();
  }

  @override
  void dispose() {
    profile.removeListener(_profileChanged);
    super.dispose();
  }

  void _profileChanged() {
    setState(() {});
  }

  Widget _buildBody() {
    const screens = [
      ProfileScreen(),
      MenuScreen(),
      CartScreen(),
      OrderHistoryScreen(),
      ReviewsScreen(),
    ];
    return IndexedStack(index: _currentIndex, children: screens);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
