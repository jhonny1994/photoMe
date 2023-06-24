import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/providers.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
          icon: const Icon(Icons.logout),
        ),
      ),
      body: Center(
        child: Text(
          message,
        ),
      ),
    );
  }
}
