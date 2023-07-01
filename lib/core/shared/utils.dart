import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String generateRandomString(int length) {
  final random = Random();

  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  return Iterable.generate(length, (idx) => chars[random.nextInt(chars.length)])
      .join();
}

Widget gap(BuildContext context, {bool isHeight = true}) => isHeight
    ? SizedBox(height: MediaQuery.of(context).viewInsets.bottom == 0 ? 32 : 16)
    : SizedBox(width: MediaQuery.of(context).viewInsets.bottom == 0 ? 32 : 16);

Widget smallGap(BuildContext context, {bool isHeight = true}) => isHeight
    ? SizedBox(height: MediaQuery.of(context).viewInsets.bottom == 0 ? 8 : 4)
    : SizedBox(width: MediaQuery.of(context).viewInsets.bottom == 0 ? 8 : 4);

Size screenSize(BuildContext context) => MediaQuery.of(context).size;

Future<String> replaceImage({
  required String bucket,
  required File image,
  required String imageUrl,
  required String userId,
  required SupabaseClient client,
}) async {
  try {
    final upload = await uploadImage(
      bucket: bucket,
      image: image,
      userId: userId,
      client: client,
    );
    await deleteImage(
      bucket: bucket,
      imageUrl: imageUrl,
      client: client,
    );
    return upload;
  } catch (e) {
    rethrow;
  }
}

Future<String> uploadImage({
  required String bucket,
  required File image,
  required String userId,
  required SupabaseClient client,
}) async {
  try {
    final path = '$userId/${generateRandomString(20)}${extension(image.path)}';
    final imageUrl = await client.storage.from(bucket).upload(path, image);
    return imageUrl;
  } catch (e) {
    rethrow;
  }
}

Future<void> deleteImage({
  required String bucket,
  required String imageUrl,
  required SupabaseClient client,
}) async {
  try {
    final path = imageUrl;
    await client.storage.from(bucket).remove([path]);
  } catch (e) {
    rethrow;
  }
}