import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/sync_service.dart';

/// Supabase-backed auth.
///
/// Email + password plus Google OAuth (native via in-app browser / system).
/// The actual Google provider must be enabled in Supabase Dashboard →
/// Authentication → Providers → Google (see supabase/GOOGLE_OAUTH_SETUP.md).
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  SupabaseClient get _client => Supabase.instance.client;
  GoTrueClient get _auth => _client.auth;

  User? get currentUser => _auth.currentUser;
  Session? get currentSession => _auth.currentSession;

  /// Emits the current auth state whenever it changes (sign-in, sign-out,
  /// token refresh, etc.).
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  Future<User?> signInWithEmail(String email, String password) async {
    final res = await _auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    return res.user;
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final res = await _auth.signUp(
      email: email.trim(),
      password: password,
    );
    return res.user;
  }

  /// Kicks off Google OAuth flow. Returns once the browser hand-off starts;
  /// the actual sign-in completion arrives via [authStateChanges].
  ///
  /// Returns `false` if the user cancels before the browser opens.
  Future<bool> signInWithGoogle() async {
    return _auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.talkverse://login-callback/',
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // Clear per-user data so a different account on the same device
    // doesn't inherit it.
    await SyncService.instance.clearLocalUserData();
  }

  /// Map Supabase auth errors to user-friendly Korean messages.
  static String friendlyErrorMessage(Object error) {
    if (error is AuthException) {
      final msg = error.message.toLowerCase();
      if (msg.contains('invalid login credentials') ||
          msg.contains('invalid_credentials')) {
        return '이메일 또는 비밀번호가 일치하지 않아요.';
      }
      if (msg.contains('email not confirmed')) {
        return '이메일 인증이 필요해요. 받은 편지함을 확인해주세요.';
      }
      if (msg.contains('user already registered') ||
          msg.contains('already registered')) {
        return '이미 가입된 이메일이에요.';
      }
      if (msg.contains('password') && msg.contains('6')) {
        return '비밀번호는 6자 이상이어야 해요.';
      }
      if (msg.contains('invalid email')) {
        return '올바른 이메일 형식이 아니에요.';
      }
      if (msg.contains('rate limit')) {
        return '요청이 너무 많아요. 잠시 후 다시 시도해주세요.';
      }
      return error.message;
    }
    return '오류가 발생했어요. 다시 시도해주세요.';
  }
}
