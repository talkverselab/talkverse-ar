import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/main_screen.dart';
import '../screens/login_screen.dart';
import '../services/sync_service.dart';
import '../theme/app_colors.dart';
import 'auth_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _syncedForUid;
  Future<void>? _syncFuture;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        // On first build before any auth event, check the current session.
        final session = snapshot.data?.session ??
            AuthService.instance.currentSession;

        if (session == null) {
          _syncedForUid = null;
          _syncFuture = null;
          return const LoginScreen();
        }

        final uid = session.user.id;
        if (_syncedForUid != uid) {
          _syncedForUid = uid;
          _syncFuture = SyncService.instance.syncUserDataOnLogin();
        }

        return FutureBuilder<void>(
          future: _syncFuture,
          builder: (context, syncSnapshot) {
            if (syncSnapshot.connectionState != ConnectionState.done) {
              return const _Loading();
            }
            return const MainScreen();
          },
        );
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/branding/welcome.png'),
                height: 220,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 32),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
