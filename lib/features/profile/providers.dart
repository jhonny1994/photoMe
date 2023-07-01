import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/features/profile/domain/profile.dart';
import 'package:photome/features/profile/infurastructure/profile_repository.dart';

final profileProvider =
    FutureProvider.family<Profile, String>((ref, profileId) async {
  return ref.read(profileRepositoryProvider).getProfile(profileId);
});

final profileFollowersCountProvider =
    FutureProvider.family<int?, String>((ref, profileId) async {
  return ref.read(profileRepositoryProvider).getFollowrsCount(profileId);
});
