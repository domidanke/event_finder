import 'package:event_finder/theme/theme.dart';
import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  const RatingBar({super.key, required this.toRate, required this.onRated});
  final String toRate;
  final Function(int rating) onRated;
  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bewerte: ${widget.toRate}',
          style: const TextStyle(fontSize: 18.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                size: 40.0,
                color: secondaryColor,
              ),
              onPressed: () {
                setState(() {
                  rating = index + 1;
                });
                widget.onRated(rating);
              },
            );
          }),
        ),
      ],
    );
  }
}
