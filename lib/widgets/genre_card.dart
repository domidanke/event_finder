import 'package:flutter/material.dart';

import '../theme/theme.dart';

class GenreCard extends StatelessWidget {
  const GenreCard({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: primaryGreen,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Text(
              text,
              style:
                  const TextStyle(fontSize: 14, color: primaryBackgroundColor),
            )),
      );
}
