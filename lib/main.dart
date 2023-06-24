// ignore_for_file: avoid_redundant_argument_values

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/loading_screen.dart';
import 'package:photome/core/providers.dart';
import 'package:photome/core/test_screen.dart';
import 'package:photome/features/auth/presentation/onboarding_screen.dart';
import 'package:photome/features/auth/presentation/sign_up_screen.dart';
import 'package:photome/features/auth/presentation/verification_screen.dart';
import 'package:photome/features/posts/presentation/posts_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    debug: false,
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider).when(
          authenticated: () => const PostsScreen(),
          failure: (message) => TestScreen(message: 'failure $message'),
          loading: () => const LoadingScreen(),
          unauthenticated: () => const SignUpScreen(),
          onboarding: () => const OnboardingScreen(),
          verification: VerificationScreen.new,
        );
    return MaterialApp(
      title: 'Photome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blueGrey,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: state,
    );
  }
}
