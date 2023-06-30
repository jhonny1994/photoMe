import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:photome/features/profile/infurastructure/profile_repository.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<UpdateProfileScreen> {
  File? image;
  bool isLoading = false;
  final username = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> selectImages() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        image = File(result.path);
      });
    }
  }

  Widget _gap() =>
      SizedBox(height: MediaQuery.of(context).viewInsets.bottom == 0 ? 32 : 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Please complete your profile!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              _gap(),
              CircleAvatar(
                radius:
                    MediaQuery.of(context).viewInsets.bottom == 0 ? 100 : 50,
                backgroundImage: image != null ? FileImage(image!) : null,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : selectImages,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
              ),
              _gap(),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  final emailValid = RegExp(
                    r'^[A-Za-z][A-Za-z0-9_]{7,29}$',
                  ).hasMatch(value);
                  if (!emailValid) {
                    return 'Please enter a valid username';
                  }
                  return null;
                },
                controller: username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              _gap(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (image != null) {
                              final operation = await ref
                                  .read(profileRepositoryProvider)
                                  .createProfile(
                                    username.text,
                                    ref
                                        .read(supabaseClientProvider)
                                        .auth
                                        .currentUser!
                                        .id,
                                    image!,
                                  );
                              operation.fold(
                                (l) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l)),
                                ),
                                (r) => ref
                                    .read(authNotifierProvider.notifier)
                                    .checkAndUpdatestate(),
                              );
                            }
                          }
                        },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
