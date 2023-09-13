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
          borderRadius:
              BorderRadius.circular(15.0), // Set the border radius here
          side: BorderSide(
            color: primaryWhite.withOpacity(0.25), // Set the border color here
            width: 2.0, // Set the border width here
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Text(
              text,
              style:
                  TextStyle(fontSize: 12, color: primaryWhite.withOpacity(0.6)),
            )),
      );
}
