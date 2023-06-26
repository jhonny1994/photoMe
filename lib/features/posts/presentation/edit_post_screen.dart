import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photome/core/providers.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:photome/features/posts/application/posts_notifier.dart';
import 'package:photome/features/posts/domain/post.dart';

class EditPostScreen extends ConsumerStatefulWidget {
  const EditPostScreen(this.post, {super.key});
  final Post post;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPostScreen> {
  @override
  void initState() {
    setState(() {
      caption.text = widget.post.caption;
    });
    super.initState();
  }

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
        title: const Text('Edit Post'),
        actions: [
          TextButton(
            onPressed: (isLoading != true && image != null ||
                    caption.text != widget.post.caption)
                ? () async {
                    setState(() {
                      isLoading = true;
                    });

                    if (image != null) {
                      final uploadJob = await ref
                          .read(postNotifierProvider.notifier)
                          .uploadImage(
                            image!,
                            ref.read(userProvider)!.id,
                          );
                      uploadJob.fold(
                        (l) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l)),
                        ),
                        (r) async {
                          final post = Post(
                            id: widget.post.id,
                            caption: caption.text,
                            imageUrl: r,
                            profileId: ref.read(userProvider)!.id,
                          );
                          final action = await ref
                              .read(postNotifierProvider.notifier)
                              .updatePost(post);
                          action.fold(
                              (l) => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l)),
                                  ), (r) {
                            ref
                                .read(postNotifierProvider.notifier)
                                .deleteImage(widget.post.imageUrl);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Post was edited successfully'),
                              ),
                            );
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    } else {
                      final post = Post(
                        caption: caption.text,
                        imageUrl: widget.post.imageUrl,
                        profileId: ref.read(userProvider)!.id,
                      );
                      final action = await ref
                          .read(postNotifierProvider.notifier)
                          .updatePost(post);
                      action.fold(
                          (l) => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l)),
                              ), (r) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Post was edited successfully'),
                          ),
                        );
                        Navigator.of(context).pop();
                      });
                    }

                    setState(() {
                      isLoading = false;
                    });
                  }
                : null,
            child: const Text('Save'),
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
                                  : DecorationImage(
                                      image: NetworkImage(
                                        ref.read(
                                          imageUrlProvider(
                                            userId: widget.post.profileId,
                                            fileName: widget.post.imageUrl,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
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
