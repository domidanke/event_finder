import 'package:flutter/material.dart';

class OnboardingPageModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color textColor;

  OnboardingPageModel(
      {required this.title,
      required this.description,
      required this.imageUrl,
      this.textColor = Colors.white});
}
