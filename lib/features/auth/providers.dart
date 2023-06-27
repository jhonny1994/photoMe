import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/features/auth/application/auth_notifier.dart';
import 'package:photome/features/auth/infurastructure/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

final userProvider = Provider<sp.User?>((ref) {
  return ref.read(supabaseClientProvider).auth.currentUser;
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref, ref.read(supabaseClientProvider));
});

final isBoardedProvider = FutureProvider<bool?>((ref) async {
  final prefs = await ref.read(prefsProvider.future);
  return prefs.getBool('isBoarded');
});
