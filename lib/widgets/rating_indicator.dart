import 'package:flutter/material.dart';

import '../models/rating_data.dart';
import '../theme/theme.dart';

class RatingIndicator extends StatelessWidget {
  const RatingIndicator(
      {super.key, required this.ratingData, this.isSmall = true});
  final RatingData? ratingData;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    if (ratingData != null) {
      return Row(
        children: [
          Text(
            (ratingData!.totalRating / ratingData!.numOfRatings)
                .toStringAsFixed(2),
            style:
                TextStyle(color: secondaryColor, fontSize: isSmall ? 12 : 24),
          ),
          const SizedBox(
            width: 2,
          ),
          Icon(
            Icons.star,
            size: isSmall ? 14 : 32,
            color: secondaryColor,
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            '(${ratingData!.numOfRatings})',
            style:
                TextStyle(color: secondaryColor, fontSize: isSmall ? 12 : 24),
          )
        ],
      );
    } else {
      return const Row(
        children: [
          Text(
            '-',
            style: TextStyle(color: secondaryColor),
          ),
          SizedBox(
            width: 2,
          ),
          Icon(
            Icons.star,
            size: 14,
            color: secondaryColor,
          )
        ],
      );
    }
  }
}
