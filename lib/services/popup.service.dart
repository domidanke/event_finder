import 'package:flutter/material.dart';

import '../theme/theme.dart';

class PopupService {
  factory PopupService() {
    return _singleton;
  }
  PopupService._internal();
  static final PopupService _singleton = PopupService._internal();

  SnackBar getCustomSnackBar(String text) {
    return SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 12,
            ),
            const Icon(
              Icons.check_circle_outline,
              color: primaryWhite,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              text,
              style: const TextStyle(color: primaryWhite),
            ),
          ],
        ),
        backgroundColor: secondaryColor.withOpacity(0.5));
  }
}
