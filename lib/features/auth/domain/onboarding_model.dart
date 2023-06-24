import 'package:flutter/material.dart';

class OnboardingPageModel {
  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.image,
    this.bgColor = Colors.blueGrey,
    this.textColor = Colors.white,
  });

  final Color bgColor;
  final String description;
  final String image;
  final Color textColor;
  final String title;
}
