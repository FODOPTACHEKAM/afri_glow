import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  String get displayName =>
      _user?.displayName ?? _user?.email?.split('@').first ?? 'Friend';

  AuthProvider() {
    // Keep _user in sync with Firebase auth state automatically.
    AuthService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ── Auth operations ────────────────────────────────────────────────────────

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _error = null;
    try {
      await AuthService.signInWithEmail(email.trim(), password);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapCode(e.code);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    _setLoading(true);
    _error = null;
    try {
      await AuthService.signUpWithEmail(email.trim(), password);
      await AuthService.updateDisplayName(name.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapCode(e.code);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _error = null;
    try {
      final cred = await AuthService.signInWithGoogle();
      return cred != null;
    } on FirebaseAuthException catch (e) {
      _error = _mapCode(e.code);
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Google sign-in failed. Please try again.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await AuthService.signOut();
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _error = null;
    try {
      await AuthService.resetPassword(email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapCode(e.code);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Error mapping ──────────────────────────────────────────────────────────

  String _mapCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error — check your connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
