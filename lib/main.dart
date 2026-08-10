import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(PoultryNowApp(initialLoggedIn: isLoggedIn));
}

class PoultryNowApp extends StatelessWidget {
  final bool initialLoggedIn;

  const PoultryNowApp({super.key, required this.initialLoggedIn});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: initialLoggedIn ? '/dashboard' : '/login',
      redirect: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        final loggedIn = prefs.getBool('isLoggedIn') ?? false;
        final loggingIn = state.matchedLocation == '/login';

        if (!loggedIn && !loggingIn) {
          return '/login';
        }
        if (loggedIn && loggingIn) {
          return '/dashboard';
        }
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: '/dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardScreen();
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'PoultryNow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
