import 'package:go_router/go_router.dart';
import 'package:photome/core/presentation/error_screen.dart';
import 'package:photome/core/presentation/loading_screen.dart';
import 'package:photome/features/auth/presentation/auth_screen.dart';
import 'package:photome/features/auth/presentation/onboarding_screen.dart';
import 'package:photome/features/auth/presentation/verification_screen.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:photome/features/posts/presentation/add_post_screen.dart';
import 'package:photome/features/posts/presentation/edit_post_screen.dart';
import 'package:photome/features/posts/presentation/posts_screen.dart';
import 'package:photome/features/profile/presentation/profile_screen.dart';
import 'package:photome/features/profile/presentation/update_profile_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/error',
        builder: (context, state) => ErrorScreen(
          message: state.queryParameters['message']!,
        ),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/verification',
        builder: (context, state) {
          final email = state.queryParameters['email']!;
          final password = state.queryParameters['password']!;
          return VerificationScreen(email, password);
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const PostsScreen(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => const AddPostScreen(),
      ),
      GoRoute(
        path: '/edit',
        builder: (context, state) => EditPostScreen(state.extra! as Post),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) =>
            ProfileScreen(profileId: state.extra! as String),
      ),
      GoRoute(
        path: '/updateProfile',
        builder: (context, state) => const UpdateProfileScreen(),
      ),
    ],
    redirect: (context, state) async {
      final authState = ref.watch(authNotifierProvider);
      return authState.when(
        authenticated: () => '/',
        failure: (message) => '/error?message=$message',
        loading: () => '/loading',
        verification: (email, password) =>
            '/verification?email=$email&password=$password',
        onboarding: () => '/onboarding',
        unauthenticated: () => '/auth',
        completeProfile: () => '/updateProfile',
      );
    },
  );
});
