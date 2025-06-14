import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/welcome_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/review_admin_screen.dart';
import 'screens/game_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/about_screen.dart';
import 'screens/addresses_screen.dart';
import 'widgets/bottom_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
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
        '/profile': (_) => const ProfileScreen(),
        '/cart': (_) => const CartScreen(),
        '/history': (_) => const OrderHistoryScreen(),
        '/reviews': (_) => const ReviewsScreen(),
        '/admin': (_) => ReviewAdminScreen(),
        '/notifications': (_) => const NotificationsScreen(),
        '/about': (_) => const AboutScreen(),
        '/addresses': (_) => const AddressesScreen(),
      },
    );
  }
}

/// Stateful widget that holds bottom navigation logic.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const ProfileScreen();
      case 1:
        return const MenuScreen();
      case 2:
        return const CartScreen();
      case 3:
        return const OrderHistoryScreen();
      case 4:
        return const ReviewsScreen();
      default:
        return const SizedBox.shrink();
    }
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
