import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage(this.url, {super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: NetworkImage(url)),
      ),
    );
  }
}
