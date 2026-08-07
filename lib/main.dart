import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/enterprises_screen.dart';
import 'screens/add_enterprise_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
    GoRoute(path: '/enterprises', builder: (context, state) => const EnterprisesScreen()),
    GoRoute(path: '/add_enterprise', builder: (context, state) => const AddEnterpriseScreen()),
  ],
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final loggedIn = username != null && username.isNotEmpty;
    final goingToLogin = state.matchedLocation == '/login';
    if (!loggedIn && !goingToLogin) return '/login';
    if (loggedIn && goingToLogin) return '/dashboard';
    return null;
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PoultryNow',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange), useMaterial3: true),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
