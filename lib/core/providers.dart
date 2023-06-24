import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/features/auth/application/auth_notifier.dart';
import 'package:photome/features/auth/infurastructure/auth_state.dart';
import 'package:photome/features/posts/application/posts_notifier.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

final supabaseClientProvider = Provider<sp.SupabaseClient>((ref) {
  return sp.Supabase.instance.client;
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref, ref.read(supabaseClientProvider));
});

final sharedPrefrencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final isBoardedProvider = FutureProvider<bool?>((ref) async {
  final prefs = await ref.read(sharedPrefrencesProvider.future);
  return prefs.getBool('isBoarded');
});

final postsNotifierProvider =
    StateNotifierProvider<PostsNotifier, AsyncValue<List<Post>>>((ref) {
  return PostsNotifier(ref.read(supabaseClientProvider));
});
