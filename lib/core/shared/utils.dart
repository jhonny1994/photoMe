import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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

Future<File?> compressFile(File file) async {
  final tempDir = await getTemporaryDirectory();
  final path = '${tempDir.path}/${basename(file.path)}';

  try {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      path,
      quality: 50,
    );
    if (result != null) {
      final newFile = File(result.path);
      return newFile;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<String> uploadImage({
  required String bucket,
  required File image,
  required String userId,
  required SupabaseClient client,
}) async {
  try {
    final newImageName = '${generateRandomString(20)}${extension(image.path)}';
    final path = '$userId/$newImageName';
    final compressedImage = await compressFile(image);
    if (compressedImage != null) {
      final imageUrl =
          await client.storage.from(bucket).upload(path, compressedImage);
      return imageUrl;
    } else {
      final imageUrl = await client.storage.from(bucket).upload(path, image);
      return imageUrl;
    }
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
    await client.storage.from(bucket).remove([imageUrl.substring(6)]);
  } catch (e) {
    rethrow;
  }
}
