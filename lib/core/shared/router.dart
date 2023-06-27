import 'package:go_router/go_router.dart';
import 'package:photome/core/presentation/error_screen.dart';
import 'package:photome/core/presentation/loading_screen.dart';
import 'package:photome/features/auth/presentation/onboarding_screen.dart';
import 'package:photome/features/auth/presentation/sign_in_screen.dart';
import 'package:photome/features/auth/presentation/sign_up_screen.dart';
import 'package:photome/features/auth/presentation/verification_screen.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:photome/features/posts/presentation/add_post_screen.dart';
import 'package:photome/features/posts/presentation/edit_post_screen.dart';
import 'package:photome/features/posts/presentation/posts_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
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
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/verification',
        builder: (context, state) {
          final email = state.queryParameters['email']!;
          final password = state.queryParameters['password']!;
          final username = state.queryParameters['username']!;
          return VerificationScreen(email, password, username);
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
    ],
    redirect: (context, state) async {
      final authState = ref.watch(authNotifierProvider);
      return authState.when(
        authenticated: () => '/',
        failure: (message) => '/error?message=$message',
        loading: () => '/loading',
        verification: (email, password, username) =>
            '/verification?email=$email&password=$password&username=$username',
        onboarding: () => '/onboarding',
        unauthenticated: (bool isSignUp) => isSignUp ? '/signup' : '/signin',
      );
    },
  );
});
