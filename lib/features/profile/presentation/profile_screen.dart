import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/presentation/error_screen.dart';
import 'package:photome/core/presentation/loading_screen.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/core/shared/utils.dart';
import 'package:photome/features/posts/providers.dart';
import 'package:photome/features/profile/presentation/update_profile_screen.dart';
import 'package:photome/features/profile/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({required this.profileId, super.key});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider(profileId));
    final posts = ref.read(getProfilePostsProvider(profileId));
    final followersCount =
        ref.watch(profileFollowersCountProvider(profileId)).asData?.value ?? 0;
    final postsCount =
        ref.watch(getProfilePostsCountProvider(profileId)).asData?.value ?? 0;
    return Scaffold(
      body: SafeArea(
        child: profile.when(
          data: (data) {
            final isMyProfile = data.id ==
                ref.read(supabaseClientProvider).auth.currentUser!.id;
            return Column(
              children: [
                AppBar(
                  title: Text(data.username!),
                  centerTitle: true,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                ref.read(
                                  imageUrlProvider(
                                    userId: data.id,
                                    fileName: data.profileImage!,
                                  ),
                                ),
                              ),
                            ),
                            smallGap(context, isHeight: false),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        followersCount.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        'Followers',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        postsCount.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        'Posts',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        smallGap(context),
                        if (isMyProfile)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: const ContinuousRectangleBorder(),
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute<Widget>(
                                      builder: (context) =>
                                          const UpdateProfileScreen(),
                                    ),
                                  ),
                                  child: const Text('Edit'),
                                ),
                              ),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: const ContinuousRectangleBorder(),
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {},
                                  child: const Text('Share'),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: const ContinuousRectangleBorder(),
                                    fixedSize: Size(
                                      screenSize(context).width * 0.475,
                                      screenSize(context).height * 0.05,
                                    ),
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Follow',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: const ContinuousRectangleBorder(),
                                    foregroundColor: Colors.black,
                                    fixedSize: Size(
                                      screenSize(context).width * 0.475,
                                      screenSize(context).height * 0.05,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Share',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        smallGap(context),
                        Expanded(
                          child: posts.when(
                            data: (data) => GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          ref.read(
                                            imageUrlProvider(
                                              userId: data
                                                  .elementAt(index)
                                                  .profileId,
                                              fileName: data
                                                  .elementAt(index)
                                                  .imageUrl,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            error: (error, stackTrace) =>
                                ErrorScreen(message: error.toString()),
                            loading: () => const LoadingScreen(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) => ErrorScreen(message: error.toString()),
          loading: () => const LoadingScreen(),
        ),
      ),
    );
  }
}
