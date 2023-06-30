import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/presentation/error_screen.dart';
import 'package:photome/core/presentation/loading_screen.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/features/profile/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({required this.profileId, super.key});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider(profileId));
    return Scaffold(
      appBar: AppBar(),
      body: profile.when(
        data: (data) => data.fold(
          (l) => ErrorScreen(message: l),
          (profile) {
            final isMyProfile = profile.id ==
                ref.read(supabaseClientProvider).auth.currentUser!.id;
            return Column(
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage(
                    ref.read(
                      imageUrlProvider(
                        userId: profile.id,
                        fileName: profile.profileImage!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '@${profile.username!}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // TODO(jhonny1994):  finish the profile section
                if (!isMyProfile)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'follow',
                        elevation: 0,
                        label: const Text('Follow'),
                        icon: const Icon(Icons.person_add_alt_1),
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'mesage',
                        elevation: 0,
                        label: const Text('Mesage'),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: const Icon(Icons.message),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'edit',
                        elevation: 0,
                        label: const Text('Edit profile'),
                        icon: const Icon(Icons.edit),
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'delete',
                        elevation: 0,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        label: const Text('Delete profile'),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
        error: (error, stackTrace) => ErrorScreen(message: error.toString()),
        loading: () => const LoadingScreen(),
      ),
    );
  }
}
