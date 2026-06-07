import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';

class AfriGlowApp extends StatelessWidget {
  const AfriGlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return MaterialApp(
      title: 'AfriGlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: provider.themeMode,
      home: const _AuthGate(),
    );
  }
}

/// Listens to Firebase auth state.
/// • No user   → LoginScreen
/// • User found → SplashScreen (loads Firestore profile + routes onward)
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still connecting to Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        // Not signed in
        if (!snapshot.hasData) {
          return const LoginScreen();
        }
        // Signed in — SplashScreen handles the Firestore load + routing
        return const SplashScreen();
      },
    );
  }
}
