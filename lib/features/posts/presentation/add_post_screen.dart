import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:photome/features/posts/application/posts_notifier.dart';
import 'package:photome/features/posts/domain/post.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  final caption = TextEditingController();
  File? image;
  bool isLoading = false;

  Future<void> selectImages() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        image = File(result.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        actions: [
          TextButton(
            onPressed: (isLoading != true &&
                    image != null &&
                    caption.text.isNotEmpty)
                ? () async {
                    setState(() {
                      isLoading = true;
                    });

                    final uploadJob = await ref
                        .read(postNotifierProvider.notifier)
                        .uploadImage(
                          image!,
                          ref.read(userProvider)!.id,
                        );
                    uploadJob.fold(
                      (l) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l),
                        ),
                      ),
                      (r) async {
                        final post = Post(
                          caption: caption.text.trim(),
                          imageUrl: r,
                          profileId: ref.read(userProvider)!.id,
                        );
                        final action = await ref
                            .read(postNotifierProvider.notifier)
                            .addPost(post);
                        action.fold(
                            (l) => ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l),
                                  ),
                                ), (r) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post added successfully'),
                            ),
                          );
                          Navigator.of(context).pop();
                        });
                      },
                    );

                    setState(() {
                      isLoading = false;
                    });
                  }
                : null,
            child: const Text('Submit'),
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              image: image != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        image!,
                                      ),
                                    )
                                  : null,
                            ),
                            child: image != null
                                ? null
                                : const Center(child: Text('Add image')),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: CircleAvatar(
                            child: image != null
                                ? IconButton(
                                    onPressed: () => setState(() {
                                      image = null;
                                    }),
                                    icon: const Icon(Icons.clear),
                                  )
                                : IconButton(
                                    onPressed: selectImages,
                                    icon: const Icon(Icons.add),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          expands: true,
                          controller: caption,
                          onChanged: (event) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: "What's on your mind?",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading)
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
