import 'dart:math';

String generateRandomString(int length) {
  final random = Random();

  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  return Iterable.generate(length, (idx) => chars[random.nextInt(chars.length)])
      .join();
}
