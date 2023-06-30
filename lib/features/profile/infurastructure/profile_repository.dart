import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/core/shared/utils.dart';
import 'package:photome/features/profile/domain/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) =>
    ProfileRepository(ref.read(supabaseClientProvider));

class ProfileRepository {
  ProfileRepository(this.client);

  final SupabaseClient client;

  Future<Either<String, Profile>> getProfile(String userId) async {
    try {
      final query = await client
          .from('profiles')
          .select<Map<String, dynamic>>()
          .match({'id': userId}).single();
      final profile = Profile.fromMap(query);
      return right(profile);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> createProfile(
    String username,
    String userId,
    File image,
  ) async {
    try {
      final imageUrl = await uploadImage(
        bucket: 'profile_pictures',
        image: image,
        userId: userId,
        client: client,
      );
      await client.from('profiles').update({
        'username': username,
        'profile_image': imageUrl,
      }).match({'id': userId});
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> updateUsername(
    String username,
    String userId,
  ) async {
    try {
      await client
          .from('profiles')
          .update({'username': username}).match({'id': userId});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserImage(
    File image,
    String imageUrl,
    String userId,
  ) async {
    try {
      await replaceImage(
        bucket: 'profile_profile',
        image: image,
        userId: userId,
        client: client,
        imageUrl: imageUrl,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<String, int>> getFollowrsCount(String profileId) async {
    try {
      final query = await client
          .from('followers')
          .select<PostgrestListResponse>(
            '*',
            const FetchOptions(
              count: CountOption.exact,
            ),
          )
          .eq('profile_id', profileId);
      return right(query.count ?? 0);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> toggleFollow(
    String profileId,
    String followerId,
  ) async {
    try {
      final query = await client
          .from('followers')
          .select<Map<String, dynamic>>()
          .eq('profile_id', profileId)
          .eq('follower_id', followerId);
      if (query.isEmpty) {
        await client
            .from('followers')
            .delete()
            .match({'profile_id': profileId, 'follower_id': followerId});
      } else {
        await client
            .from('followers')
            .insert({'profile_id': profileId, 'follower_id': followerId});
      }
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }
}
