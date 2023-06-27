import 'package:photome/core/shared/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
String imageUrl(
  ImageUrlRef ref, {
  required String userId,
  required String fileName,
}) {
  final storageUrl = ref.read(supabaseClientProvider).storageUrl;
  return '$storageUrl/object/public/$fileName';
}
