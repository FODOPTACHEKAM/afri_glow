// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import '../../theme/app_colors.dart';
import 'auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.login(email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful: \\${result['message'] ?? 'Welcome!'}')),
      );
      // TODO: Navigate to the next screen after login succeeds.
    } on ApiException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to AfriGlow',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.espresso,
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 24),
            const AuthLabel('Email Address'),
            AuthField(
              controller: emailController,
              hint: 'Enter your email',
              icon: Icons.email_rounded,
            ),
            const SizedBox(height: 16),
            const AuthLabel('Password'),
            AuthField(
              controller: passwordController,
              hint: 'Enter your password',
              icon: Icons.lock_rounded,
              obscure: true,
            ),
            const SizedBox(height: 24),
            AuthPrimaryButton(
              label: 'Sign In',
              loading: _isLoading,
              onTap: _handleLogin,
            ),
            const SizedBox(height: 16),
            const AuthOrDivider(),
            const SizedBox(height: 16),
            AuthGoogleButton(loading: false, onTap: () {}),
          ],
        ),
      ),
    );
  }
}
