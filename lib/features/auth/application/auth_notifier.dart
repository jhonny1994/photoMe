import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/features/auth/infurastructure/auth_state.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref, this.client) : super(const AuthState.loading()) {
    checkAndUpdatestate();
  }

  final sp.SupabaseClient client;
  final Ref ref;

  Future<void> checkAndUpdatestate() async {
    final isBoarded = await ref.read(isBoardedProvider.future);
    final user = ref.read(supabaseClientProvider).auth.currentUser;
    if (isBoarded != null && isBoarded != false) {
      user != null
          ? state = const AuthState.authenticated()
          : state = const AuthState.unauthenticated(isSignUp: true);
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String username,
  ) async {
    state = const AuthState.loading();
    try {
      await client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      state = AuthState.verification(
        email,
        password,
        username,
      );
    } catch (e) {
      state = AuthState.failure(e.toString());
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    state = const AuthState.loading();
    try {
      await client.auth.verifyOTP(
        email: email,
        token: otp,
        type: sp.OtpType.signup,
      );
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.failure(e.toString());
    }
  }

  Future<void> toggleBoarding({required bool isBoarded}) async {
    state = const AuthState.loading();
    final prefs = await ref.read(prefsProvider.future);
    await prefs.setBool('isBoarded', isBoarded);
    await checkAndUpdatestate();
  }

  void toggleSignInUp({required bool isSignUp}) {
    state = AuthState.unauthenticated(isSignUp: isSignUp);
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    state = const AuthState.loading();

    try {
      await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.failure(e.toString());
    }
  }

  Future<void> signOut() async {
    state = const AuthState.loading();

    try {
      await client.auth.signOut();
      await checkAndUpdatestate();
    } catch (e) {
      state = AuthState.failure(e.toString());
    }
  }
}
