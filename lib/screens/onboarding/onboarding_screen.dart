import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.spa,
              size: 100,
              color: AppTheme.naturalGreen,
            ),

            const SizedBox(height: 20),

            const Text(
              "AFRIGLOW",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBrown,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "African Natural Skin Care",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.naturalGreen,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              child: const Text("Get Started"),
            ),
          ],
        ),
      ),
    );
  }.
}