// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _apiBase = 'https://your-api.afriglow.com'; // ← change to your API URL

class AuthResult {
  final bool success;
  final String message;
  final String? userName;
  final String? redirectUrl;

  const AuthResult({
    required this.success,
    required this.message,
    this.userName,
    this.redirectUrl,
  });
}

class AuthService {
  /// Returns true when the API base is still the default placeholder.
  static bool get isDemoMode => _apiBase == 'https://your-api.afriglow.com';

  /// Attempts to sign in with [email] and [password].
  /// If [rememberMe] is true the token is persisted; otherwise only kept in
  /// memory (session-level via SharedPreferences with a session flag).
  static Future<AuthResult> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    if (isDemoMode) {
      // UI preview / demo mode — simulate a short delay then return a demo msg
      await Future.delayed(const Duration(milliseconds: 1400));
      return const AuthResult(
        success: false,
        message: 'No API connected yet — this is a UI preview.',
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$_apiBase/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'rememberMe': rememberMe,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        final msg = (data['message'] as String?) ??
            'Invalid credentials. Please try again.';
        return AuthResult(success: false, message: msg);
      }

      // Persist token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('afriglow_token', data['token'] as String? ?? '');
      await prefs.setBool('afriglow_remember', rememberMe);

      final user = data['user'] as Map<String, dynamic>?;
      final userName = user?['name'] as String?;

      return AuthResult(
        success: true,
        message: 'Welcome back!',
        userName: userName,
        redirectUrl: data['redirectUrl'] as String?,
      );
    } catch (e) {
      return const AuthResult(
        success: false,
        message: 'Could not reach the server. Please try again.',
      );
    }
  }

  /// Sends a password-reset e-mail for [email].
  static Future<AuthResult> forgotPassword(String email) async {
    if (isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      return AuthResult(
        success: true,
        message: "We've sent a reset link to $email.",
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$_apiBase/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return AuthResult(
        success: response.statusCode == 200,
        message: response.statusCode == 200
            ? "We've sent a reset link to $email."
            : 'Could not send reset link. Try again.',
      );
    } catch (_) {
      return const AuthResult(
        success: false,
        message: 'Could not reach the server. Please try again.',
      );
    }
  }
}
