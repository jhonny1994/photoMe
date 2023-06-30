import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'providers.g.dart';

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef _) {
  return Supabase.instance.client;
}

@riverpod
Future<SharedPreferences> prefs(PrefsRef _) {
  return SharedPreferences.getInstance();
}

@riverpod
String imageUrl(
  ImageUrlRef ref, {
  required String userId,
  required String fileName,
}) {
  final storageUrl = ref.read(supabaseClientProvider).storageUrl;
  return '$storageUrl/object/public/$fileName';
}
