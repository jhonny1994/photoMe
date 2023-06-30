import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/features/profile/domain/profile.dart';
import 'package:photome/features/profile/infurastructure/profile_repository.dart';

final profileProvider = FutureProvider.family<Either<String, Profile>, String>(
    (ref, profileId) async {
  return ref.read(profileRepositoryProvider).getProfile(profileId);
});
